class DashboardController < ApplicationController
  def show
    @account = current_account
    authorize @account, policy_class: DashboardPolicy

    @recent_activity = @account.audit_events
                               .order(created_at: :desc)
                               .limit(10)

    @stats = {
      members: @account.memberships.accepted.count,
      projects: @account.projects.count rescue 0,
      storage_used: calculate_storage_used,
      subscription_status: @account.subscription_status
    }
  end

  private

  def calculate_storage_used
    # Calculate total storage used by account
    # This would sum up file sizes from ActiveStorage or similar
    0
  end
end