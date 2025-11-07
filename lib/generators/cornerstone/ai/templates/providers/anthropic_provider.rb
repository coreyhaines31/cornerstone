require 'net/http'
require 'json'

module Ai
  module Providers
    class AnthropicProvider
      BASE_URL = 'https://api.anthropic.com/v1'

      def initialize
        @api_key = ENV['ANTHROPIC_API_KEY'] || ai_config.dig(:providers, :anthropic, :api_key)
        raise "Anthropic API key not configured" if @api_key.blank?
      end

      def complete(messages:, model: 'claude-3-opus-20240229', temperature: 0.7, max_tokens: 2000, **options)
        # Convert OpenAI-style messages to Anthropic format
        system_message, user_messages = convert_messages(messages)

        response = make_request(
          '/messages',
          {
            model: model,
            messages: user_messages,
            system: system_message,
            max_tokens: max_tokens,
            temperature: temperature,
            **options
          }
        )

        {
          content: response['content'].first['text'],
          usage: {
            prompt_tokens: response['usage']['input_tokens'],
            completion_tokens: response['usage']['output_tokens'],
            total_tokens: response['usage']['input_tokens'] + response['usage']['output_tokens']
          },
          model: response['model'],
          finish_reason: response['stop_reason']
        }
      end

      def stream(messages:, model: 'claude-3-opus-20240229', temperature: 0.7, max_tokens: 2000, **options, &block)
        system_message, user_messages = convert_messages(messages)

        uri = URI("#{BASE_URL}/messages")

        request = Net::HTTP::Post.new(uri)
        request['x-api-key'] = @api_key
        request['anthropic-version'] = '2023-06-01'
        request['content-type'] = 'application/json'
        request.body = {
          model: model,
          messages: user_messages,
          system: system_message,
          max_tokens: max_tokens,
          temperature: temperature,
          stream: true,
          **options
        }.to_json

        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request) do |response|
            response.read_body do |chunk|
              chunk.split("\n").each do |line|
                next unless line.start_with?("data: ")

                data = line[6..-1]
                next if data == "[DONE]"

                begin
                  parsed = JSON.parse(data)
                  if parsed['type'] == 'content_block_delta'
                    content = parsed.dig('delta', 'text')
                    yield content if content && block_given?
                  end
                rescue JSON::ParserError
                  next
                end
              end
            end
          end
        end
      end

      def embed(text:, model: nil)
        # Anthropic doesn't have native embeddings yet
        # You would need to use a different service or fallback to OpenAI
        raise "Anthropic does not currently support embeddings. Please use OpenAI or another provider for embeddings."
      end

      def models
        # Return available Claude models
        [
          'claude-3-opus-20240229',
          'claude-3-sonnet-20240229',
          'claude-3-haiku-20240307',
          'claude-2.1',
          'claude-2.0',
          'claude-instant-1.2'
        ]
      end

      private

      def convert_messages(messages)
        system_message = nil
        user_messages = []

        messages.each do |msg|
          case msg[:role]
          when 'system'
            system_message = msg[:content]
          when 'user'
            user_messages << { role: 'user', content: msg[:content] }
          when 'assistant'
            user_messages << { role: 'assistant', content: msg[:content] }
          end
        end

        # Ensure messages alternate between user and assistant
        if user_messages.any? && user_messages.first[:role] != 'user'
          user_messages.unshift({ role: 'user', content: 'Continue' })
        end

        [system_message, user_messages]
      end

      def make_request(endpoint, body, method: :post)
        uri = URI("#{BASE_URL}#{endpoint}")

        request = case method
        when :get
          Net::HTTP::Get.new(uri)
        when :post
          Net::HTTP::Post.new(uri)
        else
          raise "Unsupported HTTP method: #{method}"
        end

        request['x-api-key'] = @api_key
        request['anthropic-version'] = '2023-06-01'
        request['content-type'] = 'application/json' if method == :post
        request.body = body.to_json if method == :post && body.any?

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end

        parsed_response = JSON.parse(response.body)

        if response.code.to_i >= 400
          error_message = parsed_response['error']['message'] rescue response.body
          raise "Anthropic API Error (#{response.code}): #{error_message}"
        end

        parsed_response
      end

      def ai_config
        @ai_config ||= Rails.application.config_for(:ai) rescue {}
      end
    end
  end
end