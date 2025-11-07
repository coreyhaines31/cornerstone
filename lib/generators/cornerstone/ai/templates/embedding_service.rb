class EmbeddingService
  class << self
    def generate(text, model: nil)
      return nil if text.blank?

      provider = LlmService.provider
      model ||= ai_config[:embeddings][:model]

      response = provider.embed(text: text, model: model)
      response[:embedding]
    end

    def generate_batch(texts, model: nil)
      return [] if texts.blank?

      provider = LlmService.provider
      model ||= ai_config[:embeddings][:model]

      texts.map do |text|
        response = provider.embed(text: text, model: model)
        response[:embedding]
      end
    end

    def store(content:, embedding:, metadata: {}, embeddable: nil)
      Embedding.create!(
        content: content,
        embedding: embedding,
        metadata: metadata,
        embeddable: embeddable
      )
    end

    def search(query_text, scope: Embedding.all, limit: 10, threshold: 0.8)
      query_embedding = generate(query_text)
      return [] if query_embedding.nil?

      scope.find_similar(query_embedding, limit: limit, threshold: threshold)
    end

    def update_embeddings_for(record)
      # Generate embedding for record's searchable content
      content = extract_searchable_content(record)
      embedding = generate(content)

      # Find or create embedding record
      embedding_record = record.embeddings.first_or_initialize
      embedding_record.update!(
        content: content,
        embedding: embedding,
        metadata: {
          class_name: record.class.name,
          updated_at: Time.current
        }
      )
    end

    def index_all(model_class, batch_size: 100)
      model_class.find_in_batches(batch_size: batch_size) do |batch|
        batch.each do |record|
          update_embeddings_for(record)
        rescue => e
          Rails.logger.error "Failed to generate embedding for #{model_class}##{record.id}: #{e.message}"
        end
      end
    end

    def find_related(record, limit: 5)
      embedding = record.embeddings.first
      return [] unless embedding

      # Find similar embeddings, excluding the original
      similar = Embedding
        .where.not(id: embedding.id)
        .find_similar(embedding.embedding, limit: limit + 1)
        .reject { |e| e.embeddable == record }
        .first(limit)

      similar.map(&:embeddable).compact
    end

    private

    def extract_searchable_content(record)
      case record
      when Page
        "#{record.title} #{record.content}"
      when Post
        "#{record.title} #{record.excerpt} #{record.content}"
      when User
        "#{record.name} #{record.email} #{record.bio}"
      else
        if record.respond_to?(:searchable_content)
          record.searchable_content
        elsif record.respond_to?(:to_s)
          record.to_s
        else
          record.inspect
        end
      end
    end

    def ai_config
      @ai_config ||= Rails.application.config_for(:ai)
    end
  end

  # Instance methods for batch operations
  def initialize(model: nil)
    @model = model
  end

  def generate(text)
    self.class.generate(text, model: @model)
  end

  def generate_batch(texts)
    self.class.generate_batch(texts, model: @model)
  end

  def search(query_text, **options)
    self.class.search(query_text, **options)
  end
end