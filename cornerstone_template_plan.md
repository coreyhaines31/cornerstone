# 🧱 Cornerstone: Rails SaaS Template Blueprint

## 1. Core Modules (Ship by Default)
These are the parts every app gets, no decisions required.

### Framework & Structure
- Ruby on Rails 8+
- PostgreSQL (UUIDs by default)
- TailwindCSS via tailwindcss-rails
- Hotwire (Turbo + Stimulus)
- ViewComponent for UI primitives
- Importmap (default)
- Redis cache store for sessions, caching, and background jobs

### Authentication & Authorization
- Devise for user authentication (with magic links, TOTP, etc.)
- Pundit for per-model policies
- Pretender for admin impersonation
- Current.user + Current.account middleware
- Optional Postgres RLS pre-configured but off by default

### Multi-Account Tenancy
- Models: Account, User, Membership
- Users can belong to multiple accounts
- Turbo-powered account switcher
- Roles: owner, admin, member
- WithinAccount concern handles scoping
- Audit log for switching, invites, and settings changes

### Billing
- Billing::Gateway interface with Stripe adapter pre-installed
- Pay gem under the hood
- Webhook handling (idempotent, signed)
- Billing portal per provider

### Email Delivery
- Email::Provider interface with Resend adapter by default
- Easy swap for Postmark, SendGrid, Mailgun

### UI Kit / Components Page
- Accessible via /components
- Built with ViewComponent + Lookbook
- Components: buttons, inputs, selects, modals, tables, toasts, etc.
- Dark/light toggle

### Observability & Security
- Honeybadger or Sentry for error tracking
- Lograge for structured logs
- Rack::Attack rate limiting
- SecureHeaders, CSP, SameSite strict
- AuditEvent model
- /up and /ready health endpoints

### Developer Experience
- bin/setup & bin/dev scripts
- template.rb installer for new projects
- GitHub Actions CI (lint, test, security)
- CHANGELOG.md and upgrade.rb

---

## 2. Switchable Modules (Easy Configuration Switchers)

| Setting | Default | Alternatives |
|----------|----------|---------------|
| Auth Provider | devise | rodauth |
| Billing Provider | stripe | paddle, polar |
| Email Provider | resend | postmark, sendgrid, mailgun |
| Storage Provider | aws_s3 | r2, gcs |
| AI Provider | openai (RubyLLM) | anthropic, gemini, openrouter, ollama |
| Frontend Builder | importmap | vite, esbuild |
| Job Backend | sidekiq | solid_queue |
| Search Backend | postgres | meilisearch, algolia |

---

## 3. Optional Modules (Generators / Add-ons)

| Module | Command | Description |
|---------|----------|-------------|
| CMS | rails g cornerstone:cms | Page & Post models, inline editing, AI assist |
| Programmatic SEO | rails g cornerstone:seo | Dataset → Template → Page pipeline |
| AI Stack | rails g cornerstone:ai | RubyLLM + ActiveAgent + MCP SDK + pgvector |
| Billing Expansion | rails g cornerstone:billing <provider> | Adds adapters for Paddle/Polar |
| Email Providers | rails g cornerstone:email <provider> | Adds adapters for Postmark, SendGrid, Mailgun |
| Themes | rails g cornerstone:themes | Branding, color tokens |
| Webhooks | rails g cornerstone:webhooks | Webhook model + delivery UI |
| Analytics | rails g cornerstone:analytics | Basic attribution + dashboard |

---

## 4. Module Classification Table

| Category | Ships Default | Switchable | Optional |
|-----------|----------------|-------------|-----------|
| Rails Core | ✅ | ❌ | ❌ |
| Devise Auth | ✅ | 🔁 Rodauth | ❌ |
| Pundit Policies | ✅ | ❌ | ❌ |
| Multi-account Tenancy | ✅ | ❌ | ❌ |
| Billing (Stripe) | ✅ | 🔁 Paddle, Polar | ❌ |
| Email (Resend) | ✅ | 🔁 Postmark, SendGrid, Mailgun | ❌ |
| ActiveStorage (S3) | ✅ | 🔁 R2, GCS | ❌ |
| Job Backend (Sidekiq) | ✅ | 🔁 Solid Queue | ❌ |
| RubyLLM | ✅ | 🔁 Provider model | ❌ |
| ActiveAgent | ✅ | ✅ Toggle in config | ❌ |
| MCP SDK | ✅ | ✅ Toggle in config | ❌ |
| pgvector | ❌ | ✅ (enabled w/ AI) | ❌ |
| CMS | ❌ | ❌ | 🧩 Generator |
| Programmatic SEO | ❌ | ❌ | 🧩 Generator |
| Themes | ❌ | ❌ | 🧩 Generator |
| Webhooks | ❌ | ❌ | 🧩 Generator |
| Analytics | ❌ | ❌ | 🧩 Generator |

---

## 5. LLM-Friendly Structure (for “Vibe Coding”)

### Code Organization
```
app/
  models/
  services/
  components/
  controllers/
  policies/
  views/
lib/
  cornerstone/
    core/
    billing/
    email/
    ai/
    cms/
    seo/
config/
  cornerstone.yml
  ai.yml
  plans.yml
```

### Promptable Workflows
```
LLM.prompt("Summarize all blog posts for marketing")
ActiveAgent.run(ContentOptimizerAgent.new)
MCP::Tools::CMS.create_page(title: "Test", body: "Hello World")
```

---

## 6. Delivery Phases

1. **Phase 1:** Base template (core + switchers)
2. **Phase 2:** Generators (CMS, SEO, AI)
3. **Phase 3:** Docs site + upgrade system
4. **Phase 4:** Optional Pro pack (analytics, webhooks, CRM)
