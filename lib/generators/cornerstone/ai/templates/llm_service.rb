class LlmService
  class << self
    def provider
      @provider ||= begin
        provider_name = Cornerstone.module_setting(:ai_provider) || :openai
        provider_class = "Ai::Providers::#{provider_name.to_s.camelize}Provider"
        provider_class.constantize.new
      rescue NameError => e
        Rails.logger.error "AI Provider not found: #{provider_name}"
        raise "AI Provider #{provider_name} is not configured. Please check config/cornerstone.yml"
      end
    end

    delegate :complete, :stream, :embed, :models, to: :provider
  end

  def initialize(model: nil, temperature: nil, max_tokens: nil)
    @model = model || default_model
    @temperature = temperature || 0.7
    @max_tokens = max_tokens || 2000
  end

  def complete(prompt, system: nil, **options)
    messages = build_messages(prompt, system)

    self.class.provider.complete(
      messages: messages,
      model: options[:model] || @model,
      temperature: options[:temperature] || @temperature,
      max_tokens: options[:max_tokens] || @max_tokens,
      **options.except(:model, :temperature, :max_tokens)
    )
  end

  def stream(prompt, system: nil, **options, &block)
    messages = build_messages(prompt, system)

    self.class.provider.stream(
      messages: messages,
      model: options[:model] || @model,
      temperature: options[:temperature] || @temperature,
      max_tokens: options[:max_tokens] || @max_tokens,
      **options.except(:model, :temperature, :max_tokens),
      &block
    )
  end

  def chat(conversation, new_message, **options)
    messages = conversation.messages + [{ role: 'user', content: new_message }]

    response = self.class.provider.complete(
      messages: messages,
      model: options[:model] || @model,
      temperature: options[:temperature] || @temperature,
      max_tokens: options[:max_tokens] || @max_tokens,
      **options.except(:model, :temperature, :max_tokens)
    )

    # Update conversation
    conversation.messages = messages + [{ role: 'assistant', content: response[:content] }]
    conversation.total_tokens = (conversation.total_tokens || 0) + (response[:usage][:total_tokens] || 0)
    conversation.save!

    response
  end

  def summarize(text, max_length: 100)
    prompt = "Please summarize the following text in approximately #{max_length} words:\n\n#{text}"
    complete(prompt, system: "You are a helpful assistant that creates concise, accurate summaries.")
  end

  def extract_entities(text, entity_types: [])
    prompt = if entity_types.any?
      "Extract the following entities from the text: #{entity_types.join(', ')}\n\nText: #{text}"
    else
      "Extract all relevant entities (people, places, organizations, dates, etc.) from the text:\n\n#{text}"
    end

    complete(prompt, system: "You are an entity extraction specialist. Return results as JSON.")
  end

  def classify(text, categories:)
    prompt = "Classify the following text into one of these categories: #{categories.join(', ')}\n\nText: #{text}\n\nCategory:"
    complete(prompt, system: "You are a text classification expert. Return only the category name.")
  end

  def generate_embeddings(text)
    self.class.provider.embed(text: text, model: embedding_model)
  end

  def find_similar(embedding, limit: 10, threshold: 0.8)
    Embedding.find_similar(embedding, limit: limit, threshold: threshold)
  end

  private

  def build_messages(prompt, system = nil)
    messages = []
    messages << { role: 'system', content: system } if system.present?
    messages << { role: 'user', content: prompt }
    messages
  end

  def default_model
    ai_config[:providers][provider_name][:model] || 'gpt-4'
  end

  def embedding_model
    ai_config[:embeddings][:model] || 'text-embedding-3-small'
  end

  def provider_name
    Cornerstone.module_setting(:ai_provider) || :openai
  end

  def ai_config
    @ai_config ||= Rails.application.config_for(:ai)
  end
end