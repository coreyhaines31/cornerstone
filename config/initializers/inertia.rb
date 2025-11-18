InertiaRails.configure do |config|
  config.version = -> { ViteRuby.instance.manifest_digest }
end
