class AgentService
  attr_reader :agent, :conversation, :tools

  def initialize(agent, conversation: nil)
    @agent = agent
    @conversation = conversation || AiConversation.create!(
      user: Current.user,
      title: "Agent: #{agent.name}",
      model: agent.model,
      messages: []
    )
    @tools = load_tools(agent.tools)
  end

  def run(input, context: {})
    # Add system message with agent instructions
    system_message = build_system_message(context)

    # Build messages array
    messages = []
    messages << { role: 'system', content: system_message }
    messages += @conversation.messages
    messages << { role: 'user', content: input }

    # Get response from LLM with tool calling
    response = execute_with_tools(messages)

    # Update conversation
    @conversation.messages << { role: 'user', content: input }
    @conversation.messages << { role: 'assistant', content: response[:content] }
    @conversation.total_tokens = (@conversation.total_tokens || 0) + (response[:usage][:total_tokens] || 0)
    @conversation.save!

    response
  end

  def run_async(input, context: {})
    AgentJob.perform_later(agent: @agent, input: input, context: context)
  end

  def stream(input, context: {}, &block)
    system_message = build_system_message(context)

    messages = []
    messages << { role: 'system', content: system_message }
    messages += @conversation.messages
    messages << { role: 'user', content: input }

    buffer = ""

    LlmService.new(model: @agent.model, temperature: @agent.temperature).stream(
      messages: messages
    ) do |chunk|
      buffer += chunk
      yield chunk

      # Check if we need to call a tool
      if tool_call = extract_tool_call(buffer)
        result = execute_tool(tool_call)
        yield "\n[Tool Result: #{result}]\n"
        buffer = ""
      end
    end

    # Update conversation
    @conversation.messages << { role: 'user', content: input }
    @conversation.messages << { role: 'assistant', content: buffer }
    @conversation.save!
  end

  def reset
    @conversation.messages = []
    @conversation.total_tokens = 0
    @conversation.save!
  end

  private

  def build_system_message(context)
    message = @agent.instructions

    if @tools.any?
      message += "\n\nAvailable Tools:\n"
      @tools.each do |tool|
        message += "- #{tool.name}: #{tool.description}\n"
      end
      message += "\nTo use a tool, respond with: TOOL[tool_name](parameters)"
    end

    if context.any?
      message += "\n\nContext:\n"
      context.each do |key, value|
        message += "#{key}: #{value}\n"
      end
    end

    message
  end

  def load_tools(tool_names)
    return [] if tool_names.blank?

    tool_names.map do |tool_name|
      tool_class = "Ai::Tools::#{tool_name.camelize}Tool"
      tool_class.constantize.new
    rescue NameError => e
      Rails.logger.warn "Tool not found: #{tool_name}"
      nil
    end.compact
  end

  def execute_with_tools(messages)
    max_iterations = 5
    iteration = 0

    loop do
      iteration += 1
      break if iteration > max_iterations

      response = LlmService.new(
        model: @agent.model,
        temperature: @agent.temperature
      ).complete(messages: messages)

      # Check if the response contains a tool call
      if tool_call = extract_tool_call(response[:content])
        # Execute the tool
        tool_result = execute_tool(tool_call)

        # Add tool use and result to messages
        messages << { role: 'assistant', content: response[:content] }
        messages << { role: 'tool', content: tool_result }

        # Continue the conversation
        next
      else
        # No tool call, return the response
        return response
      end
    end

    # Max iterations reached
    { content: "I apologize, but I couldn't complete the task within the iteration limit.", usage: {} }
  end

  def extract_tool_call(content)
    return nil unless content.include?("TOOL[")

    if match = content.match(/TOOL\[(\w+)\]\((.*?)\)/)
      {
        name: match[1],
        parameters: parse_tool_parameters(match[2])
      }
    end
  end

  def parse_tool_parameters(params_string)
    return {} if params_string.blank?

    # Try to parse as JSON first
    JSON.parse(params_string)
  rescue JSON::ParserError
    # Fallback to simple key:value parsing
    params = {}
    params_string.split(',').each do |param|
      key, value = param.split(':').map(&:strip)
      params[key] = value if key.present?
    end
    params
  end

  def execute_tool(tool_call)
    tool = @tools.find { |t| t.name == tool_call[:name] }
    return "Tool not found: #{tool_call[:name]}" unless tool

    begin
      result = tool.execute(**tool_call[:parameters].symbolize_keys)
      "Success: #{result}"
    rescue => e
      "Error executing tool: #{e.message}"
    end
  end
end

class AgentJob < ApplicationJob
  queue_as :ai

  def perform(agent:, input:, context: {})
    service = AgentService.new(agent)
    service.run(input, context: context)
  end
end