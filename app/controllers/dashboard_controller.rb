class DashboardController < ApplicationController
  layout "inertia"

  def show
    account = current_account
    authorize account, policy_class: DashboardPolicy

    render inertia: "Dashboard", props: {
      user: user_payload,
      account: account_payload(account),
      stats: dashboard_stats(account),
      highlights: dashboard_highlights(account),
      activity: dashboard_activity(account),
      tasks: dashboard_tasks(account)
    }
  end

  private

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
      plan: account.plan_name,
      subscription_status: account.subscription_status || "trialing"
    }
  end

  def dashboard_stats(account)
    [
      {
        label: "Members",
        value: account&.memberships&.accepted&.count.to_i,
        change: "+3 this week"
      },
      {
        label: "Projects",
        value: safe_project_count(account),
        change: "Stable"
      },
      {
        label: "Storage used",
        value: helpers.number_to_human_size(calculate_storage_used),
        change: "Optimized"
      },
      {
        label: "Plan",
        value: (account&.plan_name || "Free"),
        change: (account&.subscription_status || "trialing").to_s.titleize
      }
    ]
  end

  def dashboard_highlights(account)
    [
      {
        title: "Invite your team",
        description: "Add teammates to collaborate on projects and approvals.",
        badge: "Collaboration"
      },
      {
        title: "Stay on top of billing",
        description: "Review usage, plan, and invoices to avoid surprises.",
        badge: account&.plan_name || "Free"
      },
      {
        title: "Secure the workspace",
        description: "Enable 2FA or SSO to protect your account.",
        badge: "Security"
      }
    ]
  end

  def dashboard_activity(account)
    return [] unless account

    account.audit_events.order(created_at: :desc).limit(6).map do |event|
      {
        id: event.id,
        action: event.action.humanize,
        actor: event.user&.name || "System",
        description: event.description,
        occurred_at: event.created_at.iso8601
      }
    end
  end

  def dashboard_tasks(account)
    [
      {
        id: "TASK-2873",
        title: "Kick off Q2 planning",
        owner: current_user&.name || "You",
        status: "In progress",
        due_on: 7.days.from_now.to_date.iso8601
      },
      {
        id: "TASK-1834",
        title: "Invite the leadership team",
        owner: account&.owner&.name || "Account owner",
        status: "Blocked",
        due_on: 3.days.from_now.to_date.iso8601
      },
      {
        id: "TASK-4421",
        title: "Enable security baseline",
        owner: "Security",
        status: "Ready to start",
        due_on: 14.days.from_now.to_date.iso8601
      }
    ]
  end

  def safe_project_count(account)
    account&.respond_to?(:projects) ? account.projects.count : 0
  rescue StandardError
    0
  end

  def calculate_storage_used
    # Calculate total storage used by account
    # This would sum up file sizes from ActiveStorage or similar
    0
  end
end
