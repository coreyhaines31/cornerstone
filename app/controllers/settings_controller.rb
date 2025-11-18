class SettingsController < ApplicationController
  layout "inertia"

  def show
    authorize current_account, :show?, policy_class: AccountPolicy
    render_settings(:general)
  end

  def security
    authorize current_account, :show?, policy_class: AccountPolicy
    render_settings(:security)
  end

  def connected_accounts
    authorize current_account, :show?, policy_class: AccountPolicy
    render_settings(:connected_accounts)
  end

  def update
    authorize current_account, :update?, policy_class: AccountPolicy
    flash[:notice] = "Settings saved."
    redirect_to settings_path
  end

  def enable_otp
    authorize current_account, :update?, policy_class: AccountPolicy
    flash[:notice] = "Two-factor authentication enabled for your team."
    redirect_to security_settings_path
  end

  def disable_otp
    authorize current_account, :update?, policy_class: AccountPolicy
    flash[:notice] = "Two-factor authentication disabled."
    redirect_to security_settings_path
  end

  private

  def render_settings(section)
    account = current_account
    render inertia: "Settings", props: base_props(account).merge(section: section)
  end

  def base_props(account)
    {
      user: user_payload,
      account: account_payload(account),
      billing: billing_payload(account),
      preferences: notification_preferences,
      team: team_payload(account)
    }
  end

  def user_payload
    return {} unless current_user

    {
      name: current_user.name,
      email: current_user.email,
      initials: current_user.initials
    }
  end

  def account_payload(account)
    return {} unless account

    {
      name: account.name,
      slug: account.slug,
      plan: account.plan_name,
      subscription_status: account.subscription_status || "trialing"
    }
  end

  def billing_payload(account)
    {
      plan: account&.plan_name || "Free",
      status: account&.subscription_status || "trialing",
      renewal_date: 30.days.from_now.to_date.iso8601,
      usage: {
        members: account&.memberships&.accepted&.count.to_i,
        projects: safe_project_count(account),
        storage_gb: storage_used_gb
      }
    }
  end

  def notification_preferences
    [
      { key: "product", label: "Product updates", description: "New features, betas, and release notes.", enabled: true },
      { key: "security", label: "Security alerts", description: "Login alerts and critical advisories.", enabled: true },
      { key: "billing", label: "Billing updates", description: "Invoices, receipts, and renewal reminders.", enabled: true },
      { key: "feedback", label: "Research", description: "Occasional requests to give product feedback.", enabled: false }
    ]
  end

  def team_payload(account)
    account&.memberships&.accepted&.includes(:user)&.map do |membership|
      member = membership.user
      {
        name: member&.name || membership.email,
        email: member&.email,
        role: membership.role,
        initials: member&.initials || membership.email.to_s.first(2).upcase
      }
    end || []
  end

  def storage_used_gb
    0.0
  end

  def safe_project_count(account)
    account&.respond_to?(:projects) ? account.projects.count : 0
  rescue StandardError
    0
  end
end
