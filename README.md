# 🧱 Cornerstone Rails SaaS Template

A production-ready Rails template for building multi-tenant SaaS applications. Ships with authentication, authorization, billing, multi-tenancy, and a beautiful UI component library out of the box.

## ✨ Features

### Core Modules (Ship by Default)

- **🚀 Rails 8+** with PostgreSQL (UUIDs) and Redis
- **🎨 TailwindCSS** with dark/light mode support
- **⚡ Hotwire** (Turbo + Stimulus) for modern interactivity
- **🎯 Rails Icons** with Heroicons and Bootstrap Icons for beautiful UI
- **🔐 Authentication** via Devise with magic links and TOTP
- **🛡️ Authorization** via Pundit with per-model policies
- **🏢 Multi-tenancy** with Account, User, and Membership models
- **💳 Billing** with Stripe integration via Pay gem
- **📧 Email delivery** with swappable providers (Resend default)
- **🔒 Security** with Rack::Attack, SecureHeaders, and CSP
- **📊 Observability** with Honeybadger and structured logging

### Switchable Modules

Configure different providers in `config/cornerstone.yml`:

| Module | Default | Alternatives |
|--------|---------|--------------|
| Auth | Devise | Rodauth |
| Billing | Stripe | Paddle, Polar |
| Email | Resend | Postmark, SendGrid, Mailgun |
| Storage | AWS S3 | R2, GCS |
| AI | OpenAI | Anthropic, Gemini, Ollama |
| Jobs | Sidekiq | Solid Queue |
| Search | PostgreSQL | Meilisearch, Algolia |

### Optional Modules (via Generators)

```bash
rails g cornerstone:cms        # Page & Post models with inline editing
rails g cornerstone:seo        # Programmatic SEO pipeline
rails g cornerstone:ai         # AI stack with LLM support
rails g cornerstone:webhooks   # Webhook delivery system
rails g cornerstone:analytics  # Basic analytics dashboard
```

## 🚀 Quick Start

### Using the Template

```bash
# Create a new Rails app with Cornerstone
rails new myapp -m https://raw.githubusercontent.com/coreyhaines31/cornerstone/main/template.rb

# Or clone and use locally
git clone https://github.com/coreyhaines31/cornerstone.git
rails new myapp -m cornerstone/template.rb

cd myapp
bin/setup
bin/dev
```

### Environment Setup

```bash
cp .env.example .env
# Edit .env with your API keys:
# - Stripe keys
# - Resend API key
# - Honeybadger API key
```

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