SecureHeaders::Configuration.default do |config|
  # Cookie security settings
  if Rails.env.production?
    config.cookies = {
      secure: true, # Mark cookies as secure in production
      httponly: true, # Mark cookies as httponly by default
      samesite: {
        strict: true # Mark cookies as SameSite=Strict by default
      }
    }
  else
    config.cookies = SecureHeaders::OPT_OUT # Opt out of cookie security in development
  end

  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w[origin-when-cross-origin strict-origin-when-cross-origin]

  # CSP configuration for Rails with Hotwire
  config.csp = {
    default_src: %w['self'],
    font_src: %w['self' data:],
    img_src: %w['self' data: https:],
    object_src: %w['none'],
    script_src: %w['self' 'unsafe-inline'], # Allow inline scripts for importmap and module scripts
    style_src: %w['self' 'unsafe-inline'], # Allow inline styles for Tailwind
    connect_src: %w['self'],
    base_uri: %w['self'],
    form_action: %w['self'],
    frame_ancestors: %w['none'],
    upgrade_insecure_requests: true
  }

  # Add WebSocket support in development
  if Rails.env.development?
    config.csp[:connect_src] << 'ws://localhost:3000' # For ActionCable in development
  end
end
