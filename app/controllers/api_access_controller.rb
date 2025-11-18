class ApiAccessController < ApplicationController
  layout "inertia"

  def show
    account = current_account
    authorize account, :show?, policy_class: AccountPolicy

    render inertia: "ApiAccess", props: {
      account: account_payload(account),
      user: user_payload,
      api_keys: api_keys_payload,
      webhooks: webhooks_payload
    }
  end

  private

  def account_payload(account)
    return {} unless account

    {
      name: account.name,
      plan: account.plan_name,
      subscription_status: account.subscription_status || "trialing"
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

  def api_keys_payload
    [
      { name: "Production key", last_used_at: 2.hours.ago.iso8601, prefix: "pk_live_", status: "active" },
      { name: "Staging key", last_used_at: 1.day.ago.iso8601, prefix: "pk_test_", status: "active" }
    ]
  end

  def webhooks_payload
    [
      { url: "https://example.com/webhooks", status: "healthy", last_event_at: 1.hour.ago.iso8601 },
      { url: "https://staging.example.com/webhooks", status: "retrying", last_event_at: 3.hours.ago.iso8601 }
    ]
  end
end
