# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Cornerstone is a Rails SaaS template that provides a comprehensive foundation for building multi-tenant SaaS applications. It follows a modular architecture with core features that ship by default, switchable modules for different provider choices, and optional modules that can be added via generators.

## Commands

### Rails Project Setup and Development
```bash
# Initial setup
bin/setup

# Development server
bin/dev

# Rails generators for optional modules
rails g cornerstone:cms              # Add CMS functionality
rails g cornerstone:seo              # Add programmatic SEO
rails g cornerstone:ai               # Add AI stack (RubyLLM + ActiveAgent + MCP SDK + pgvector)
rails g cornerstone:billing <provider>  # Add billing provider (paddle/polar)
rails g cornerstone:email <provider>    # Add email provider (postmark/sendgrid/mailgun)
rails g cornerstone:themes           # Add theming support
rails g cornerstone:webhooks         # Add webhook model + delivery UI
rails g cornerstone:analytics        # Add basic attribution + dashboard

# Testing
bundle exec rspec                    # Run all tests
bundle exec rspec spec/path/to/spec.rb  # Run specific test file
bundle exec rspec spec/path/to/spec.rb:42  # Run specific test line

# Database
rails db:migrate
rails db:rollback
rails db:seed

# Console
rails console
rails c

# Background jobs
bundle exec sidekiq
```

## Architecture

### Module Organization
The project follows a modular architecture with clear separation:
- **Core Modules** (app/): Standard Rails structure with models, controllers, views, services, components, and policies
- **Cornerstone Library** (lib/cornerstone/): Contains isolated module implementations for billing, email, AI, CMS, and SEO
- **Configuration** (config/): Module-specific configs in cornerstone.yml, ai.yml, plans.yml

### Key Design Patterns

1. **Provider Interfaces**: Billing and Email modules use provider interfaces allowing easy swapping:
   - `Billing::Gateway` interface with Stripe adapter (swappable for Paddle/Polar)
   - `Email::Provider` interface with Resend adapter (swappable for Postmark/SendGrid/Mailgun)

2. **Multi-Tenancy**:
   - Built around Account → Membership ← User relationships
   - `WithinAccount` concern handles automatic scoping
   - `Current.user` and `Current.account` middleware for request context
   - Account switching handled via Turbo

3. **Authentication & Authorization**:
   - Devise handles user authentication with magic links and TOTP support
   - Pundit policies for per-model authorization
   - Pretender for admin impersonation
   - Optional Postgres RLS (pre-configured but disabled by default)

4. **UI Components**:
   - ViewComponent-based component system
   - Accessible via /components route with Lookbook integration
   - TailwindCSS with dark/light mode support
   - Hotwire (Turbo + Stimulus) for interactivity

5. **AI Integration** (when enabled):
   - RubyLLM for LLM provider abstraction
   - ActiveAgent for agent workflows
   - MCP SDK for tool integration
   - pgvector for embeddings storage

### Database
- PostgreSQL with UUIDs by default
- Redis for sessions, caching, and background job queues
- AuditEvent model for tracking important actions

### Security & Observability
- Rack::Attack for rate limiting
- SecureHeaders with CSP and SameSite strict
- Structured logging with Lograge
- Error tracking via Honeybadger or Sentry
- Health endpoints at /up and /ready

### Deployment & CI
- GitHub Actions for CI (lint, test, security checks)
- Upgrade system via upgrade.rb script
- CHANGELOG.md for version tracking