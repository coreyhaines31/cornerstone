require_relative '../base_generator'

module Cornerstone
  module Generators
    class AiGenerator < BaseGenerator
      source_root File.expand_path('templates', __dir__)

      def check_dependencies
        unless gem_installed?('ruby-openai') || gem_installed?('anthropic')
          say "Adding AI provider gems..."
          add_gem 'ruby-openai'
          add_gem 'anthropic'
          add_gem 'pgvector'
          run 'bundle install'
        end
      end

      def enable_pgvector
        generate "migration", "enable_pgvector"
        migration_file = Dir.glob("db/migrate/*_enable_pgvector.rb").first
        gsub_file migration_file, /def change\n  end/, <<~RUBY
          def change
            enable_extension 'vector' unless extension_enabled?('vector')
          end
        RUBY
      end

      def create_models
        generate "model", "Embedding",
                 "content:text",
                 "embedding:vector",
                 "metadata:jsonb",
                 "embeddable:references{polymorphic}"

        generate "model", "AiConversation",
                 "user:references",
                 "title:string",
                 "model:string",
                 "messages:jsonb",
                 "total_tokens:integer"

        generate "model", "AiAgent",
                 "name:string:uniq",
                 "description:text",
                 "instructions:text",
                 "tools:jsonb",
                 "model:string",
                 "temperature:float"
      end

      def create_services
        template "llm_service.rb", "app/services/llm_service.rb"
        template "embedding_service.rb", "app/services/embedding_service.rb"
        template "agent_service.rb", "app/services/agent_service.rb"
      end

      def create_providers
        directory "providers", "app/services/ai/providers"
      end

      def create_tools
        directory "tools", "app/services/ai/tools"
      end

      def update_configuration
        gsub_file "config/cornerstone.yml",
                  "ai_features: false",
                  "ai_features: true"
      end

      private

      def gem_installed?(name)
        Gem::Specification.find_by_name(name)
      rescue Gem::LoadError
        false
      end

      def add_gem(name)
        append_to_file 'Gemfile', "\ngem '#{name}'"
      end
    end
  end
end