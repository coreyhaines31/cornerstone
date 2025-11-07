source "https://rubygems.org"

ruby "3.3.0"

# Rails and core gems
gem "rails", "~> 8.0.0"
gem "pg", "~> 1.5"
gem "puma", ">= 5.0"
gem "redis", "~> 5.0"

# Asset pipeline and frontend
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails", "~> 3.0"
gem "view_component", "~> 3.0"
gem "phlex-icons", "~> 1.0" # Icon library with Heroicons, etc.

# Authentication & Authorization
gem "devise", "~> 4.9"
gem "devise-two-factor", "~> 5.0"
gem "pundit", "~> 2.3"
gem "pretender", "~> 0.4"
gem "rotp", "~> 6.3" # For OTP
gem "rqrcode", "~> 2.2" # For QR codes

# Billing
gem "pay", "~> 7.0"
gem "stripe", "~> 10.0"

# Background jobs
gem "sidekiq", "~> 7.2"

# File uploads
gem "image_processing", "~> 1.12"

# Security
gem "rack-attack", "~> 6.7"
gem "secure_headers", "~> 6.5"

# Observability & Monitoring
gem "honeybadger", "~> 5.0"
gem "lograge", "~> 0.14"

# Pagination
gem "kaminari", "~> 1.2"

# JSON handling
gem "jbuilder"

# Use Active Model has_secure_password
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # Debugging
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities
  gem "brakeman", require: false

  # Omakase Ruby styling
  gem "rubocop-rails-omakase", require: false

  # Testing
  gem "rspec-rails", "~> 6.0"
  gem "factory_bot_rails", "~> 6.4"
  gem "faker", "~> 3.2"

  # Environment variables
  gem "dotenv-rails", "~> 2.8"

  # Better console
  gem "pry-rails", "~> 0.3"

  # Security
  gem "bundler-audit", "~> 0.9"

  # Code quality
  gem "standard", "~> 1.0"
  gem "erb_lint", "~> 0.5"
end

group :development do
  # Use console on exceptions pages
  gem "web-console"

  # Performance monitoring
  gem "bullet", "~> 7.1"
  gem "rack-mini-profiler"

  # Component previews
  gem "lookbook", "~> 2.0"

  # Email preview
  gem "letter_opener", "~> 1.8"

  # Better error pages
  gem "better_errors", "~> 2.10"
  gem "binding_of_caller", "~> 1.0"
end

group :test do
  # System testing
  gem "capybara", "~> 3.39"
  gem "selenium-webdriver", "~> 4.15"

  # Test helpers
  gem "shoulda-matchers", "~> 5.3"

  # HTTP mocking
  gem "webmock", "~> 3.19"
  gem "vcr", "~> 6.2"

  # Code coverage
  gem "simplecov", "~> 0.22", require: false
end

# Optional: Add these based on feature flags in config/cornerstone.yml

# Email providers (choose one or swap via config)
gem "resend", "~> 0.8" # Default
# gem "postmark-rails", "~> 0.22"
# gem "sendgrid-ruby", "~> 6.6"

# AI features (optional, enabled via generator)
# gem "ruby-openai", "~> 6.0"
# gem "anthropic", "~> 0.1"
# gem "pgvector", "~> 0.2"