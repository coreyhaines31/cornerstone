# 🧱 Cornerstone Rails SaaS Template

A Rails 8 SaaS template foundation with modern UI, authentication, and multi-tenancy. Built for rapid development with a clean, modular architecture.

## 🎯 Current Status

**Version**: 0.1.0 (Early Development)

This is an actively developed template. See below for what's currently shipped vs. planned.

## ✨ Features

### ✅ Currently Implemented

- **🚀 Rails 8.0.4** with PostgreSQL (UUIDs)
- **🎨 TailwindCSS** with dark/light mode support
- **⚡ Hotwire** (Turbo + Stimulus) ready
- **🎯 Heroicons** via rails_icons gem (1,289+ icons)
- **🔐 Authentication** via Devise (email/password configured)
- **🛡️ Authorization** via Pundit (base setup complete)
- **🏢 Multi-tenancy** with Account, User, and Membership models
- **📄 Pages** - Homepage, Dashboard, Styleguide
- **🎨 Icon Helper** - Convenient methods for all Heroicons

### 🚧 In Progress / Planned

- **💳 Billing** - Stripe/Paddle/Polar integration
- **📧 Email** - Provider abstraction (Resend/Postmark/SendGrid/Mailgun)
- **🔒 Security** - Rack::Attack, SecureHeaders, and CSP
- **📊 Observability** - Honeybadger/Sentry integration
- **🤖 AI Features** - LLM integration, agent workflows
- **📝 CMS** - Content management system
- **🔍 SEO** - Programmatic SEO tools
- **🪝 Webhooks** - Webhook delivery system
- **📈 Analytics** - Basic attribution dashboard

### 📋 Planned: Switchable Modules

Future goal: Configure different providers in `config/cornerstone.yml`:

| Module | Planned Default | Planned Alternatives |
|--------|-----------------|----------------------|
| Billing | Stripe | Paddle, Polar |
| Email | Resend | Postmark, SendGrid, Mailgun |
| Storage | AWS S3 | R2, GCS |
| AI | OpenAI | Anthropic, Gemini, Ollama |
| Jobs | Sidekiq | Solid Queue |

### 📋 Planned: Optional Modules (via Generators)

Future generators to extend functionality:

```bash
rails g cornerstone:cms        # Page & Post models with inline editing
rails g cornerstone:seo        # Programmatic SEO pipeline
rails g cornerstone:ai         # AI stack with LLM support
rails g cornerstone:webhooks   # Webhook delivery system
rails g cornerstone:analytics  # Basic analytics dashboard
```

*Note: These generators are not yet implemented.*

## 🚀 Quick Start

### Development Setup

Currently, the best way to use Cornerstone is to clone and develop directly:

```bash
# Clone the repository
git clone https://github.com/coreyhaines31/cornerstone.git
cd cornerstone

# Install dependencies and setup database
bin/setup

# Start the development server
bin/dev
```

The server will start on http://localhost:3000

### What You'll See

After setup, you'll have access to:
- **Homepage** at http://localhost:3000
- **Styleguide** at http://localhost:3000/styleguide (component reference)
- **Sign up/Login** via Devise at /users/sign_up

### Environment Setup

Basic environment variables (optional for now):

```bash
cp .env.example .env
# Edit .env as needed:
# - APP_NAME (defaults to "Cornerstone")
# - APP_HOST (defaults to "localhost:3000")
```

*Note: Billing, email, and other integrations are not yet required.*

## 📁 Project Structure

```
app/
├── components/        # ViewComponent UI library
├── controllers/       # Rails controllers
├── models/           # Active Record models
├── policies/         # Pundit authorization policies
├── services/         # Business logic services
└── views/            # Rails views

lib/
└── cornerstone/      # Core template modules
    ├── core/         # Core functionality
    ├── billing/      # Billing adapters
    ├── email/        # Email provider adapters
    ├── ai/           # AI provider integrations
    └── generators/   # Module generators

config/
├── cornerstone.yml   # Module configuration
├── ai.yml           # AI provider settings
└── plans.yml        # Subscription plans
```

## 🛠️ Development

### Commands

```bash
bin/setup     # Initial setup (installs dependencies, prepares database)
bin/dev       # Start development servers (Rails + Tailwind CSS watcher)
bin/test      # Run test suite
bin/lint      # Run linters
```

### Development Server

The `bin/dev` command starts all necessary processes using Foreman:
- **Rails server** on port 3000 (http://localhost:3000)
- **Tailwind CSS watcher** for live CSS compilation

The server runs on **port 3000** by default. If you need to change the port, you can:

```bash
# Temporarily for one session
PORT=4000 bin/dev

# Or edit Procfile.dev to change it permanently
# Change the first line to: web: bin/rails server -p 4000
```

You can also run processes individually if needed:

```bash
rails server        # Just the Rails server
rails tailwindcss:watch  # Just the CSS watcher
```

### Running Tests

```bash
bundle exec rspec              # Run all tests
bundle exec rspec spec/models  # Run model tests
bundle exec rspec spec/system  # Run system tests
```

### Code Quality

```bash
bundle exec standard           # Ruby style guide
bundle exec erb_lint           # ERB linting
bundle exec brakeman           # Security analysis
bundle exec bundler-audit      # Dependency audit
```

## 🔄 Upgrading

Cornerstone includes an upgrade script to help you update to newer versions:

```bash
# Upgrade to latest version
ruby upgrade.rb

# Upgrade to specific version
ruby upgrade.rb 1.2.0

# Dry run to see what would change
ruby upgrade.rb --dry-run
```

## 🚢 Deployment

The template is configured for deployment to:

- **Heroku** - One-click deploy ready
- **Render** - Blueprint included
- **Fly.io** - fly.toml configuration
- **Docker** - Dockerfile included
- **Any VPS** - Capistrano ready

### Heroku Deploy

```bash
heroku create myapp
heroku addons:create heroku-postgresql:mini
heroku addons:create heroku-redis:mini
git push heroku main
heroku run rails db:migrate
```

### Environment Variables

Required environment variables for production:

```bash
DATABASE_URL          # PostgreSQL connection
REDIS_URL            # Redis connection
SECRET_KEY_BASE      # Rails secret
STRIPE_SECRET_KEY    # Stripe API key
RESEND_API_KEY       # Email provider key
HONEYBADGER_API_KEY  # Error tracking
```

## 📚 Documentation

- [Getting Started Guide](docs/getting-started.md)
- [Module Configuration](docs/modules.md)
- [Multi-tenancy Guide](docs/multi-tenancy.md)
- [Billing Integration](docs/billing.md)
- [AI Features](docs/ai-features.md)
- [Deployment Guide](docs/deployment.md)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

Cornerstone is built on the shoulders of giants:

- Rails framework and the Rails community
- All the amazing gem authors whose work powers this template
- The SaaS founders who've shared their learnings

## 🔗 Links

- [GitHub Repository](https://github.com/coreyhaines31/cornerstone)
- [Documentation](https://cornerstone-rails.com)
- [Discord Community](https://discord.gg/cornerstone)
- [Twitter Updates](https://twitter.com/cornerstone_rb)

---

Built with ❤️ for Rails developers who want to ship faster.