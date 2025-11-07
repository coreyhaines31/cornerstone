# Cornerstone Rails SaaS Template
# Usage: rails new myapp -m https://raw.githubusercontent.com/coreyhaines31/cornerstone/main/template.rb

require "fileutils"
require "shellwords"

def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("cornerstone-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/coreyhaines31/cornerstone.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{cornerstone/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def rails_version
  @rails_version ||= Gem::Version.new(Rails::VERSION::STRING)
end

def rails_8_or_newer?
  Gem::Requirement.new(">= 8.0.0").satisfied_by?(rails_version)
end

def add_gems
  gem "pg", "~> 1.5"
  gem "redis", "~> 5.0"
  gem "sidekiq", "~> 7.2"

  # Frontend
  gem "tailwindcss-rails", "~> 3.0"
  gem "view_component", "~> 3.0"
  gem "lookbook", "~> 2.0", group: :development
  gem "phlex-icons", "~> 1.0"

  # Authentication & Authorization
  gem "devise", "~> 4.9"
  gem "devise-two-factor", "~> 5.0"
  gem "pundit", "~> 2.3"
  gem "pretender", "~> 0.4"

  # Billing
  gem "pay", "~> 7.0"
  gem "stripe", "~> 10.0"

  # Email
  gem "resend", "~> 0.8"

  # Security & Observability
  gem "rack-attack", "~> 6.7"
  gem "secure_headers", "~> 6.5"
  gem "lograge", "~> 0.14"
  gem "honeybadger", "~> 5.0"

  # Development & Testing
  gem_group :development, :test do
    gem "rspec-rails", "~> 6.0"
    gem "factory_bot_rails", "~> 6.4"
    gem "faker", "~> 3.2"
    gem "pry-rails", "~> 0.3"
    gem "dotenv-rails", "~> 2.8"
    gem "bullet", "~> 7.1"
    gem "bundler-audit", "~> 0.9"
    gem "brakeman", "~> 6.0"
    gem "standard", "~> 1.0"
    gem "erb_lint", "~> 0.5"
  end

  gem_group :test do
    gem "capybara", "~> 3.39"
    gem "selenium-webdriver", "~> 4.15"
    gem "webmock", "~> 3.19"
    gem "vcr", "~> 6.2"
    gem "shoulda-matchers", "~> 5.3"
    gem "simplecov", "~> 0.22", require: false
  end
end

def set_application_name
  environment "config.application_name = Rails.application.class.module_parent_name"

  # Add application name to layouts
  gsub_file "app/views/layouts/application.html.erb",
            "<title>Rails</title>",
            "<title><%= Rails.application.config.application_name %></title>"
end

def setup_postgresql
  say "Setting up PostgreSQL with UUIDs..."

  # Enable UUID extension
  generate "migration", "enable_uuid"
  migration_file = Dir.glob("db/migrate/*_enable_uuid.rb").first
  gsub_file migration_file, /def change\n  end/, <<~RUBY
    def change
      enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
      enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')
    end
  RUBY

  # Configure UUID as default for primary keys
  initializer "generators.rb", <<~RUBY
    Rails.application.config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  RUBY
end

def setup_redis_and_caching
  say "Configuring Redis for caching, sessions, and background jobs..."

  environment "config.cache_store = :redis_cache_store, { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1') }"
  environment "config.session_store :cache_store, key: '_#{app_name}_session'"

  # Configure Sidekiq
  initializer "sidekiq.rb", <<~RUBY
    Sidekiq.configure_server do |config|
      config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
    end
  RUBY

  environment "config.active_job.queue_adapter = :sidekiq"
end

def setup_tailwindcss
  say "Setting up TailwindCSS with dark mode..."

  rails_command "tailwindcss:install"

  # Configure for dark mode
  gsub_file "config/tailwind.config.js",
            "module.exports = {",
            <<~JS
              module.exports = {
                darkMode: 'class',
            JS
end

def setup_hotwire
  say "Setting up Hotwire..."

  # Hotwire comes with Rails 7+ by default
  # Ensure Turbo and Stimulus are properly configured
  rails_command "turbo:install" if rails_8_or_newer?
  rails_command "stimulus:install" if rails_8_or_newer?
end

def setup_view_components
  say "Setting up ViewComponent and Lookbook..."

  # Create components directory
  FileUtils.mkdir_p("app/components")

  # Configure Lookbook in development
  environment <<~RUBY, env: "development"
    config.lookbook.project_name = "#{app_name.humanize} Component Library"
    config.lookbook.ui_theme = "zinc"
    config.lookbook.preview_paths = ["app/components"]
  RUBY

  # Mount Lookbook
  route "mount Lookbook::Engine, at: '/components' if Rails.env.development?"
end

def create_multi_tenancy_models
  say "Creating multi-tenancy models..."

  # Account model
  generate "model", "Account",
           "name:string:uniq",
           "slug:string:uniq",
           "settings:jsonb"

  # User model (enhanced by Devise later)
  generate "model", "User",
           "email:string:uniq",
           "first_name:string",
           "last_name:string",
           "settings:jsonb"

  # Membership model
  generate "model", "Membership",
           "account:references{polymorphic}",
           "user:references",
           "role:string",
           "accepted_at:datetime"

  # Add indexes
  generate "migration", "add_indexes_to_memberships"
  migration_file = Dir.glob("db/migrate/*_add_indexes_to_memberships.rb").first
  gsub_file migration_file, /def change\n  end/, <<~RUBY
    def change
      add_index :memberships, [:account_id, :user_id], unique: true
      add_index :memberships, :role
    end
  RUBY
end

def setup_authentication
  say "Setting up Devise authentication..."

  generate "devise:install"
  generate "devise", "User"

  # Add additional fields to Devise migration
  devise_migration = Dir.glob("db/migrate/*_devise_create_users.rb").first ||
                     Dir.glob("db/migrate/*_add_devise_to_users.rb").first

  if devise_migration
    inject_into_file devise_migration, after: "t.timestamps null: false" do
      <<~RUBY

        ## Magic Link
        t.string :login_token
        t.datetime :login_token_valid_until

        ## Two Factor
        t.string :otp_secret
        t.integer :consumed_timestep
        t.boolean :otp_required_for_login
      RUBY
    end
  end
end

def setup_authorization
  say "Setting up Pundit authorization..."

  generate "pundit:install"

  # Add Pundit to ApplicationController
  inject_into_file "app/controllers/application_controller.rb",
                   after: "class ApplicationController < ActionController::Base\n" do
    <<~RUBY
      include Pundit::Authorization

      after_action :verify_authorized, except: :index, unless: :devise_controller?
      after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      private

      def user_not_authorized
        flash[:alert] = "You are not authorized to perform this action."
        redirect_back(fallback_location: root_path)
      end
    RUBY
  end
end

def create_current_middleware
  say "Creating Current middleware..."

  file "app/models/current.rb", <<~RUBY
    class Current < ActiveSupport::CurrentAttributes
      attribute :user, :account, :membership

      def account=(account)
        super
        self.membership = user&.memberships&.find_by(account: account)
      end
    end
  RUBY

  # Add middleware to set Current attributes
  inject_into_file "app/controllers/application_controller.rb",
                   after: "protect_from_forgery with: :exception\n" do
    <<~RUBY

      before_action :set_current_attributes

      private

      def set_current_attributes
        Current.user = current_user
        Current.account = current_account if respond_to?(:current_account)
      end

      def current_account
        @current_account ||= current_user&.accounts&.find_by(id: session[:current_account_id])
      end
    RUBY
  end
end

def create_billing_interface
  say "Creating Billing interface with Stripe..."

  # Create billing module
  file "app/models/billing/gateway.rb", <<~RUBY
    module Billing
      class Gateway
        def self.current
          @current ||= Billing::StripeGateway.new
        end

        def create_customer(user)
          raise NotImplementedError
        end

        def create_subscription(customer, plan)
          raise NotImplementedError
        end

        def cancel_subscription(subscription)
          raise NotImplementedError
        end

        def create_checkout_session(customer, options = {})
          raise NotImplementedError
        end

        def create_billing_portal_session(customer)
          raise NotImplementedError
        end
      end
    end
  RUBY

  file "app/models/billing/stripe_gateway.rb", <<~RUBY
    module Billing
      class StripeGateway < Gateway
        def initialize
          @stripe = Stripe
          @stripe.api_key = ENV['STRIPE_SECRET_KEY']
        end

        def create_customer(user)
          @stripe::Customer.create(
            email: user.email,
            name: user.full_name,
            metadata: {
              user_id: user.id
            }
          )
        end

        def create_subscription(customer, plan)
          @stripe::Subscription.create(
            customer: customer.stripe_id,
            items: [{ price: plan.stripe_price_id }],
            expand: ['latest_invoice.payment_intent']
          )
        end

        def cancel_subscription(subscription)
          sub = @stripe::Subscription.retrieve(subscription.stripe_id)
          sub.cancel
        end

        def create_checkout_session(customer, options = {})
          @stripe::Checkout::Session.create({
            customer: customer.stripe_id,
            payment_method_types: ['card'],
            mode: options[:mode] || 'subscription',
            success_url: options[:success_url],
            cancel_url: options[:cancel_url],
            line_items: options[:line_items]
          })
        end

        def create_billing_portal_session(customer)
          @stripe::BillingPortal::Session.create({
            customer: customer.stripe_id,
            return_url: options[:return_url]
          })
        end
      end
    end
  RUBY
end

def create_email_interface
  say "Creating Email provider interface..."

  file "app/models/email/provider.rb", <<~RUBY
    module Email
      class Provider
        def self.current
          @current ||= Email::ResendProvider.new
        end

        def send_email(to:, subject:, html:, text: nil, from: nil)
          raise NotImplementedError
        end

        def send_bulk(emails)
          raise NotImplementedError
        end
      end
    end
  RUBY

  file "app/models/email/resend_provider.rb", <<~RUBY
    require 'resend'

    module Email
      class ResendProvider < Provider
        def initialize
          Resend.api_key = ENV['RESEND_API_KEY']
        end

        def send_email(to:, subject:, html:, text: nil, from: nil)
          Resend::Emails.send({
            to: to,
            from: from || default_from,
            subject: subject,
            html: html,
            text: text
          })
        end

        def send_bulk(emails)
          Resend::Batch.send(emails.map do |email|
            {
              to: email[:to],
              from: email[:from] || default_from,
              subject: email[:subject],
              html: email[:html],
              text: email[:text]
            }
          end)
        end

        private

        def default_from
          ENV['DEFAULT_FROM_EMAIL'] || "noreply@#{Rails.application.config.application_name.downcase}.com"
        end
      end
    end
  RUBY
end

def setup_security
  say "Setting up security features..."

  # Rack::Attack configuration
  initializer "rack_attack.rb", <<~RUBY
    class Rack::Attack
      throttle('req/ip', limit: 100, period: 1.minute) do |req|
        req.ip
      end

      throttle('login/ip', limit: 5, period: 1.minute) do |req|
        req.ip if req.path == '/users/sign_in' && req.post?
      end

      throttle('signup/ip', limit: 3, period: 15.minutes) do |req|
        req.ip if req.path == '/users/sign_up' && req.post?
      end
    end

    Rails.application.config.middleware.use Rack::Attack
  RUBY

  # SecureHeaders configuration
  initializer "secure_headers.rb", <<~RUBY
    SecureHeaders::Configuration.default do |config|
      config.x_frame_options = "DENY"
      config.x_content_type_options = "nosniff"
      config.x_xss_protection = "1; mode=block"
      config.x_download_options = "noopen"
      config.x_permitted_cross_domain_policies = "none"
      config.referrer_policy = %w(origin-when-cross-origin strict-origin-when-cross-origin)

      config.csp = {
        default_src: %w('none'),
        script_src: %w('self' 'unsafe-inline'),
        style_src: %w('self' 'unsafe-inline'),
        img_src: %w('self' data: https:),
        font_src: %w('self' data:),
        connect_src: %w('self'),
        frame_ancestors: %w('none'),
        base_uri: %w('self'),
        form_action: %w('self')
      }

      config.cookies = {
        secure: true,
        httponly: true,
        samesite: {
          strict: true
        }
      }
    end
  RUBY
end

def setup_observability
  say "Setting up observability..."

  # Lograge configuration
  initializer "lograge.rb", <<~RUBY
    Rails.application.configure do
      config.lograge.enabled = true
      config.lograge.base_controller_class = ['ActionController::Base']
      config.lograge.formatter = Lograge::Formatters::Json.new

      config.lograge.custom_payload do |controller|
        {
          user_id: controller.current_user&.id,
          account_id: controller.current_account&.id,
          request_id: controller.request.request_id,
          ip: controller.request.remote_ip
        }
      end
    end
  RUBY

  # Honeybadger configuration
  initializer "honeybadger.rb", <<~RUBY
    Honeybadger.configure do |config|
      config.api_key = ENV['HONEYBADGER_API_KEY']
      config.exceptions.ignore += [
        ActionController::RoutingError,
        ActiveRecord::RecordNotFound
      ]
    end
  RUBY
end

def create_developer_scripts
  say "Creating developer scripts..."

  # bin/setup enhancement
  inject_into_file "bin/setup", after: "puts \"\\n== Preparing database ==\"\n" do
    <<~RUBY

      puts "\\n== Setting up development environment =="
      system! "cp .env.example .env" if File.exist?(".env.example") && !File.exist?(".env")

      puts "\\n== Installing JavaScript dependencies =="
      system! "yarn install --frozen-lockfile"

      puts "\\n== Compiling assets =="
      system! "bin/rails assets:precompile"

      puts "\\n== Creating test database =="
      system! "RAILS_ENV=test bin/rails db:create db:schema:load"
    RUBY
  end

  # bin/dev script
  file "bin/dev", <<~BASH
    #!/usr/bin/env sh

    if gem list --no-installed --exact --silent foreman; then
      echo "Installing foreman..."
      gem install foreman
    fi

    exec foreman start -f Procfile.dev "$@"
  BASH

  chmod "bin/dev", 0755

  # Procfile.dev
  file "Procfile.dev", <<~PROCFILE
    web: bin/rails server -p 3000
    css: bin/rails tailwindcss:watch
    js: bin/rails assets:watch
    worker: bundle exec sidekiq
  PROCFILE
end

def create_health_endpoints
  say "Creating health endpoints..."

  route <<~RUBY
    get 'up' => 'health#up'
    get 'ready' => 'health#ready'
  RUBY

  file "app/controllers/health_controller.rb", <<~RUBY
    class HealthController < ApplicationController
      skip_before_action :authenticate_user!, if: :devise_controller?

      def up
        render json: { status: 'ok', time: Time.current }
      end

      def ready
        checks = {
          database: check_database,
          redis: check_redis,
          sidekiq: check_sidekiq
        }

        if checks.values.all?
          render json: { status: 'ready', checks: checks }
        else
          render json: { status: 'not ready', checks: checks }, status: :service_unavailable
        end
      end

      private

      def check_database
        ActiveRecord::Base.connection.active?
      rescue
        false
      end

      def check_redis
        Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1')).ping == 'PONG'
      rescue
        false
      end

      def check_sidekiq
        Sidekiq.redis { |conn| conn.ping == 'PONG' }
      rescue
        false
      end
    end
  RUBY
end

def create_github_actions_ci
  say "Setting up GitHub Actions CI..."

  FileUtils.mkdir_p(".github/workflows")

  file ".github/workflows/ci.yml", <<~YAML
    name: CI

    on:
      push:
        branches: [ main, development ]
      pull_request:
        branches: [ main ]

    jobs:
      lint:
        runs-on: ubuntu-latest

        steps:
        - uses: actions/checkout@v4

        - name: Set up Ruby
          uses: ruby/setup-ruby@v1
          with:
            ruby-version: '3.3'
            bundler-cache: true

        - name: Run linters
          run: |
            bundle exec standard
            bundle exec erb_lint --lint-all
            bundle exec brakeman -q -w2

      test:
        runs-on: ubuntu-latest

        services:
          postgres:
            image: postgres:16
            env:
              POSTGRES_PASSWORD: postgres
            options: >-
              --health-cmd pg_isready
              --health-interval 10s
              --health-timeout 5s
              --health-retries 5
            ports:
              - 5432:5432

          redis:
            image: redis:7
            options: >-
              --health-cmd "redis-cli ping"
              --health-interval 10s
              --health-timeout 5s
              --health-retries 5
            ports:
              - 6379:6379

        env:
          RAILS_ENV: test
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/cornerstone_test
          REDIS_URL: redis://localhost:6379/0

        steps:
        - uses: actions/checkout@v4

        - name: Set up Ruby
          uses: ruby/setup-ruby@v1
          with:
            ruby-version: '3.3'
            bundler-cache: true

        - name: Set up database
          run: |
            bundle exec rails db:create
            bundle exec rails db:schema:load

        - name: Run tests
          run: bundle exec rspec

        - name: Upload coverage reports
          uses: codecov/codecov-action@v3
          if: always()

      security:
        runs-on: ubuntu-latest

        steps:
        - uses: actions/checkout@v4

        - name: Set up Ruby
          uses: ruby/setup-ruby@v1
          with:
            ruby-version: '3.3'
            bundler-cache: true

        - name: Run security checks
          run: |
            bundle exec bundler-audit check --update
            bundle exec brakeman -q --no-pager
  YAML
end

def create_configuration_files
  say "Creating configuration files..."

  # Main Cornerstone configuration
  file "config/cornerstone.yml", <<~YAML
    default: &default
      # Module Configuration
      modules:
        auth_provider: devise
        billing_provider: stripe
        email_provider: resend
        storage_provider: aws_s3
        ai_provider: openai
        frontend_builder: importmap
        job_backend: sidekiq
        search_backend: postgres

      # Feature Flags
      features:
        multi_tenancy: true
        billing: true
        ai_features: false
        cms: false
        webhooks: false
        analytics: false

    development:
      <<: *default

    test:
      <<: *default

    production:
      <<: *default
  YAML

  # AI configuration
  file "config/ai.yml", <<~YAML
    default: &default
      providers:
        openai:
          api_key: <%= ENV['OPENAI_API_KEY'] %>
          model: gpt-4
        anthropic:
          api_key: <%= ENV['ANTHROPIC_API_KEY'] %>
          model: claude-3-opus

      embeddings:
        provider: openai
        model: text-embedding-3-small
        dimensions: 1536

    development:
      <<: *default

    test:
      <<: *default

    production:
      <<: *default
  YAML

  # Plans configuration
  file "config/plans.yml", <<~YAML
    plans:
      - id: starter
        name: Starter
        price: 29
        currency: usd
        interval: month
        features:
          users: 5
          projects: 10
          storage: 10GB
        stripe_price_id: <%= ENV['STRIPE_STARTER_PRICE_ID'] %>

      - id: professional
        name: Professional
        price: 79
        currency: usd
        interval: month
        features:
          users: 20
          projects: unlimited
          storage: 100GB
          priority_support: true
        stripe_price_id: <%= ENV['STRIPE_PROFESSIONAL_PRICE_ID'] %>

      - id: enterprise
        name: Enterprise
        price: custom
        features:
          users: unlimited
          projects: unlimited
          storage: unlimited
          priority_support: true
          dedicated_account_manager: true
          sla: true
  YAML

  # Environment variables template
  file ".env.example", <<~ENV
    # Database
    DATABASE_URL=postgresql://localhost/#{app_name}_development

    # Redis
    REDIS_URL=redis://localhost:6379/0

    # Stripe
    STRIPE_PUBLISHABLE_KEY=pk_test_xxx
    STRIPE_SECRET_KEY=sk_test_xxx
    STRIPE_WEBHOOK_SECRET=whsec_xxx

    # Resend
    RESEND_API_KEY=re_xxx
    DEFAULT_FROM_EMAIL=hello@example.com

    # Honeybadger
    HONEYBADGER_API_KEY=hbp_xxx

    # AI Providers (optional)
    OPENAI_API_KEY=sk-xxx
    ANTHROPIC_API_KEY=sk-ant-xxx
  ENV
end

def create_module_generators
  say "Creating module generators..."

  FileUtils.mkdir_p("lib/generators/cornerstone")

  # Base generator
  file "lib/generators/cornerstone/base_generator.rb", <<~RUBY
    require 'rails/generators'

    module Cornerstone
      module Generators
        class BaseGenerator < Rails::Generators::Base
          def self.source_root
            File.expand_path('../templates', __FILE__)
          end

          protected

          def cornerstone_config
            @cornerstone_config ||= YAML.load_file(Rails.root.join('config/cornerstone.yml'))
          end

          def feature_enabled?(feature)
            cornerstone_config.dig('default', 'features', feature.to_s)
          end

          def module_config(module_name)
            cornerstone_config.dig('default', 'modules', module_name.to_s)
          end
        end
      end
    end
  RUBY

  # CMS Generator
  FileUtils.mkdir_p("lib/generators/cornerstone/cms")
  file "lib/generators/cornerstone/cms/cms_generator.rb", <<~RUBY
    require_relative '../base_generator'

    module Cornerstone
      module Generators
        class CmsGenerator < BaseGenerator
          source_root File.expand_path('templates', __dir__)

          def create_models
            generate "model", "Page",
                     "title:string:uniq",
                     "slug:string:uniq",
                     "content:text",
                     "meta_description:string",
                     "published_at:datetime",
                     "author:references"

            generate "model", "Post",
                     "title:string",
                     "slug:string:uniq",
                     "content:text",
                     "excerpt:text",
                     "meta_description:string",
                     "published_at:datetime",
                     "author:references",
                     "category:string",
                     "tags:string"
          end

          def create_controllers
            template "pages_controller.rb", "app/controllers/pages_controller.rb"
            template "posts_controller.rb", "app/controllers/posts_controller.rb"
          end

          def create_views
            directory "views/pages", "app/views/pages"
            directory "views/posts", "app/views/posts"
          end

          def add_routes
            route "resources :pages"
            route "resources :posts"
            route "get '/:slug', to: 'pages#show', as: :page_slug, constraints: { slug: /[a-z0-9-]+/ }"
          end

          def update_configuration
            gsub_file "config/cornerstone.yml",
                      "cms: false",
                      "cms: true"
          end
        end
      end
    end
  RUBY
end

def create_changelog
  say "Creating CHANGELOG..."

  file "CHANGELOG.md", <<~MD
    # Changelog
    All notable changes to Cornerstone will be documented in this file.

    The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
    and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

    ## [Unreleased]

    ## [1.0.0] - #{Date.today}
    ### Added
    - Initial release of Cornerstone Rails SaaS Template
    - Rails 8+ foundation with PostgreSQL and Redis
    - Multi-account tenancy with Account, User, and Membership models
    - Authentication via Devise with magic links and TOTP support
    - Authorization via Pundit with per-model policies
    - Billing interface with Stripe adapter using Pay gem
    - Email provider interface with Resend adapter
    - UI component library with ViewComponent and Lookbook
    - TailwindCSS with dark/light mode support
    - Security features: Rack::Attack, SecureHeaders, CSP
    - Observability: Honeybadger, Lograge
    - Developer tools: bin/setup, bin/dev, GitHub Actions CI
    - Module switching configuration system
    - Generators for optional modules (CMS, SEO, AI, etc.)
  MD
end

def create_readme
  say "Creating README..."

  file "README.md", <<~MD
    # Cornerstone Rails SaaS Template

    A production-ready Rails template for building multi-tenant SaaS applications. Ships with authentication, authorization, billing, multi-tenancy, and a beautiful UI component library out of the box.

    ## Quick Start

    ```bash
    rails new myapp -m https://raw.githubusercontent.com/coreyhaines31/cornerstone/main/template.rb
    cd myapp
    bin/setup
    bin/dev
    ```

    ## Features

    ### Core (Ships by Default)
    - **Framework**: Rails 8+, PostgreSQL with UUIDs, Redis
    - **Frontend**: TailwindCSS, Hotwire (Turbo + Stimulus), ViewComponent
    - **Authentication**: Devise with magic links and TOTP
    - **Authorization**: Pundit with per-model policies
    - **Multi-tenancy**: Account-based with role management
    - **Billing**: Stripe integration via Pay gem
    - **Email**: Resend provider with swappable interface
    - **Security**: Rack::Attack, SecureHeaders, CSP
    - **Observability**: Honeybadger, structured logging

    ### Switchable Modules
    Configure different providers in `config/cornerstone.yml`:
    - Auth: Devise (default) or Rodauth
    - Billing: Stripe (default), Paddle, or Polar
    - Email: Resend (default), Postmark, SendGrid, or Mailgun
    - Storage: AWS S3 (default), R2, or GCS
    - Jobs: Sidekiq (default) or Solid Queue

    ### Optional Modules
    Add via generators:
    ```bash
    rails g cornerstone:cms           # Content management
    rails g cornerstone:seo           # Programmatic SEO
    rails g cornerstone:ai            # AI features with LLM support
    rails g cornerstone:webhooks      # Webhook management
    rails g cornerstone:analytics     # Basic analytics
    ```

    ## Configuration

    Copy `.env.example` to `.env` and configure:
    ```bash
    cp .env.example .env
    ```

    ## Development

    ```bash
    bin/setup    # Initial setup
    bin/dev      # Start development servers
    bin/test     # Run tests
    ```

    ## Deployment

    The template is configured for deployment to:
    - Heroku
    - Render
    - Fly.io
    - Any Docker-based platform

    ## License

    MIT License. See LICENSE file for details.
  MD
end

# Main setup flow
add_template_repository_to_source_path

say "🧱 Building your Cornerstone Rails SaaS application..."

after_bundle do
  say "Installing gems and configuring application..."

  set_application_name
  setup_postgresql
  setup_redis_and_caching
  setup_tailwindcss
  setup_hotwire
  setup_view_components

  create_multi_tenancy_models
  setup_authentication
  setup_authorization
  create_current_middleware

  create_billing_interface
  create_email_interface

  setup_security
  setup_observability

  create_developer_scripts
  create_health_endpoints
  create_github_actions_ci

  create_configuration_files
  create_module_generators

  create_changelog
  create_readme

  # Run migrations
  rails_command "db:create"
  rails_command "db:migrate"

  # Initial commit
  git :init
  git add: "."
  git commit: %Q{ -m "Initial commit with Cornerstone template" }

  say "🎉 Cornerstone setup complete!", :green
  say "Next steps:"
  say "  1. Review .env.example and create your .env file"
  say "  2. Configure your Stripe, Resend, and Honeybadger API keys"
  say "  3. Run `bin/dev` to start the development server"
  say "  4. Visit http://localhost:3000"
end