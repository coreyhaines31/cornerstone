require 'net/http'
require 'json'

module Ai
  module Providers
    class OpenaiProvider
      BASE_URL = 'https://api.openai.com/v1'

      def initialize
        @api_key = ENV['OPENAI_API_KEY'] || ai_config.dig(:providers, :openai, :api_key)
        raise "OpenAI API key not configured" if @api_key.blank?
      end

      def complete(messages:, model: 'gpt-4', temperature: 0.7, max_tokens: 2000, **options)
        response = make_request(
          '/chat/completions',
          {
            model: model,
            messages: messages,
            temperature: temperature,
            max_tokens: max_tokens,
            **options
          }
        )

        {
          content: response['choices'].first['message']['content'],
          usage: response['usage'].symbolize_keys,
          model: response['model'],
          finish_reason: response['choices'].first['finish_reason']
        }
      end

      def stream(messages:, model: 'gpt-4', temperature: 0.7, max_tokens: 2000, **options, &block)
        uri = URI("#{BASE_URL}/chat/completions")

        request = Net::HTTP::Post.new(uri)
        request['Authorization'] = "Bearer #{@api_key}"
        request['Content-Type'] = 'application/json'
        request.body = {
          model: model,
          messages: messages,
          temperature: temperature,
          max_tokens: max_tokens,
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
                  content = parsed.dig('choices', 0, 'delta', 'content')
                  yield content if content && block_given?
                rescue JSON::ParserError
                  next
                end
              end
            end
          end
        end
      end

      def embed(text:, model: 'text-embedding-3-small')
        response = make_request(
          '/embeddings',
          {
            model: model,
            input: text
          }
        )

        {
          embedding: response['data'].first['embedding'],
          usage: response['usage'].symbolize_keys,
          model: response['model']
        }
      end

      def models
        response = make_request('/models', {}, method: :get)
        response['data'].map { |m| m['id'] }.sort
      end

      def moderate(text)
        response = make_request(
          '/moderations',
          { input: text }
        )

        response['results'].first
      end

      def transcribe(audio_file_path, model: 'whisper-1')
        uri = URI("#{BASE_URL}/audio/transcriptions")

        request = Net::HTTP::Post::Multipart.new(uri,
          'file' => UploadIO.new(audio_file_path, 'audio/mpeg'),
          'model' => model
        )
        request['Authorization'] = "Bearer #{@api_key}"

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end

        JSON.parse(response.body)
      end

      def generate_image(prompt:, size: '1024x1024', quality: 'standard', n: 1)
        response = make_request(
          '/images/generations',
          {
            model: 'dall-e-3',
            prompt: prompt,
            size: size,
            quality: quality,
            n: n
          }
        )

        response['data'].map { |img| img['url'] }
      end

      private

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

        request['Authorization'] = "Bearer #{@api_key}"
        request['Content-Type'] = 'application/json' if method == :post
        request.body = body.to_json if method == :post && body.any?

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end

        parsed_response = JSON.parse(response.body)

        if response.code.to_i >= 400
          error_message = parsed_response['error']['message'] rescue response.body
          raise "OpenAI API Error (#{response.code}): #{error_message}"
        end

        parsed_response
      end

      def ai_config
        @ai_config ||= Rails.application.config_for(:ai) rescue {}
      end
    end
  end
end