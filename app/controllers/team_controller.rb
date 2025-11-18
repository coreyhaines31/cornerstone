class TeamController < ApplicationController
  layout "inertia"

  def show
    account = current_account
    authorize account, :show?, policy_class: AccountPolicy

    render inertia: "Team", props: {
      account: account_payload(account),
      user: user_payload,
      members: member_payload(account),
      invitations: invitations_payload
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

  def member_payload(account)
    account&.memberships&.accepted&.includes(:user)&.map do |membership|
      member = membership.user
      {
        name: member&.name || membership.email,
        email: member&.email || membership.email,
        role: membership.role,
        status: "active",
        initials: member&.initials || membership.email.to_s.first(2).upcase
      }
    end || []
  end

  def invitations_payload
    [
      { email: "new-member@example.com", role: "member", sent_at: 1.day.ago.iso8601 },
      { email: "pending@example.com", role: "admin", sent_at: 2.days.ago.iso8601 }
    ]
  end
end
