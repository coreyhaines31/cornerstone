class ProfilesController < ApplicationController
  layout "inertia"

  def show
    authorize current_user, policy_class: ProfilePolicy
    render_profile
  end

  def edit
    authorize current_user, policy_class: ProfilePolicy
    render_profile(mode: "edit")
  end

  def update
    authorize current_user, policy_class: ProfilePolicy
    flash[:notice] = "Profile updated."
    redirect_to profile_path
  end

  private

  def render_profile(mode: "view")
    render inertia: "Profile", props: profile_props.merge(mode: mode)
  end

  def profile_props
    account = current_account

    {
      user: user_payload,
      account: account_payload(account),
      preferences: preference_payload,
      sessions: session_payload,
      highlights: highlights_payload
    }
  end

  def user_payload
    return {} unless current_user

    membership = current_user.membership_for(current_account)

    {
      name: current_user.name,
      first_name: current_user.first_name,
      last_name: current_user.last_name,
      email: current_user.email,
      initials: current_user.initials,
      role: membership&.role || "member"
    }
  end

  def account_payload(account)
    return {} unless account

    {
      name: account.name,
      plan: account.plan_name,
      subscription_status: account.subscription_status || "trialing"
    }
  end

  def preference_payload
    [
      { key: "weekly_summary", label: "Weekly summary", description: "Digest of activity, alerts, and suggestions.", enabled: true },
      { key: "product_tips", label: "Product tips", description: "Fast tips for new and existing features.", enabled: false },
      { key: "security", label: "Security alerts", description: "Unusual sign-ins, device approvals, and 2FA changes.", enabled: true }
    ]
  end

  def session_payload
    [
      { location: "Chicago, IL", device: "MacBook Pro · Safari", last_active_at: 1.hour.ago.iso8601, current: true },
      { location: "Austin, TX", device: "iPhone · Mobile Safari", last_active_at: 2.days.ago.iso8601, current: false },
      { location: "Remote", device: "Windows · Chrome", last_active_at: 1.week.ago.iso8601, current: false }
    ]
  end

  def highlights_payload
    [
      { title: "Complete your profile", description: "Add a photo and title so teammates recognize you." },
      { title: "Set up account recovery", description: "Store a backup email and enable 2FA to prevent lockouts." },
      { title: "Control notifications", description: "Pick delivery preferences for product, billing, and security." }
    ]
  end
end
