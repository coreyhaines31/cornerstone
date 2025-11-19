InertiaRails.configure do |config|
  # Use Vite manifest.json file modification time as version
  # This ensures client gets fresh assets when manifest changes
  config.version = -> do
    if Rails.env.production?
      # In production, use manifest.json digest for cache busting
      manifest_path = Rails.root.join('public', 'vite', '.vite', 'manifest.json')
      File.exist?(manifest_path) ? Digest::MD5.file(manifest_path).hexdigest : '1'
    else
      # In development, use timestamp to always get fresh assets
      Time.current.to_i.to_s
    end
  end
end
