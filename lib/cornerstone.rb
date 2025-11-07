require "cornerstone/version"
require "cornerstone/configuration"

module Cornerstone
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.config
    @config ||= begin
      config_file = Rails.root.join("config/cornerstone.yml")
      if config_file.exist?
        config = YAML.load_file(config_file, aliases: true)
        env_config = config[Rails.env] || config["default"]
        ActiveSupport::HashWithIndifferentAccess.new(env_config)
      else
        ActiveSupport::HashWithIndifferentAccess.new
      end
    end
  end

  def self.feature_enabled?(feature)
    config.dig("features", feature.to_s) == true
  end

  def self.module_setting(module_name)
    config.dig("modules", module_name.to_s)
  end
end