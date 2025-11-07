module Cornerstone
  class Configuration
    attr_accessor :auth_provider,
                  :billing_provider,
                  :email_provider,
                  :storage_provider,
                  :ai_provider,
                  :frontend_builder,
                  :job_backend,
                  :search_backend

    attr_accessor :multi_tenancy_enabled,
                  :billing_enabled,
                  :ai_features_enabled,
                  :cms_enabled,
                  :webhooks_enabled,
                  :analytics_enabled

    def initialize
      # Default providers
      @auth_provider = :devise
      @billing_provider = :stripe
      @email_provider = :resend
      @storage_provider = :aws_s3
      @ai_provider = :openai
      @frontend_builder = :importmap
      @job_backend = :sidekiq
      @search_backend = :postgres

      # Default features
      @multi_tenancy_enabled = true
      @billing_enabled = true
      @ai_features_enabled = false
      @cms_enabled = false
      @webhooks_enabled = false
      @analytics_enabled = false
    end

    def load_from_yaml(path)
      return unless File.exist?(path)

      config = YAML.load_file(path, aliases: true)
      env_config = config[Rails.env] || config["default"] || {}

      # Load module settings
      if modules = env_config["modules"]
        @auth_provider = modules["auth_provider"]&.to_sym || @auth_provider
        @billing_provider = modules["billing_provider"]&.to_sym || @billing_provider
        @email_provider = modules["email_provider"]&.to_sym || @email_provider
        @storage_provider = modules["storage_provider"]&.to_sym || @storage_provider
        @ai_provider = modules["ai_provider"]&.to_sym || @ai_provider
        @frontend_builder = modules["frontend_builder"]&.to_sym || @frontend_builder
        @job_backend = modules["job_backend"]&.to_sym || @job_backend
        @search_backend = modules["search_backend"]&.to_sym || @search_backend
      end

      # Load feature flags
      if features = env_config["features"]
        @multi_tenancy_enabled = features["multi_tenancy"] != false
        @billing_enabled = features["billing"] != false
        @ai_features_enabled = features["ai_features"] == true
        @cms_enabled = features["cms"] == true
        @webhooks_enabled = features["webhooks"] == true
        @analytics_enabled = features["analytics"] == true
      end
    end
  end
end