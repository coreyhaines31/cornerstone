class SubscriptionsController < ApplicationController
  before_action :require_account_owner!, only: [:new, :create, :cancel]

  def new
    @account = current_account
    @plans = Rails.application.config_for(:plans)['plans']
    authorize @account, :update?
  end

  def create
    @account = current_account
    authorize @account, :update?

    plan_id = params[:plan_id]
    plan = find_plan(plan_id)

    if plan.nil?
      flash[:alert] = "Invalid plan selected."
      redirect_to new_subscription_path
      return
    end

    # Create Stripe checkout session
    session = Billing::Gateway.current.create_checkout_session(
      @account,
      {
        mode: 'subscription',
        success_url: subscription_success_url,
        cancel_url: new_subscription_url,
        line_items: [{
          price: plan['stripe_price_id'],
          quantity: 1
        }],
        metadata: {
          account_id: @account.id,
          user_id: current_user.id,
          plan_id: plan_id
        }
      }
    )

    redirect_to session.url, allow_other_host: true
  end

  def success
    @account = current_account
    flash[:notice] = "Thank you for subscribing! Your account has been upgraded."
    redirect_to dashboard_path
  end

  def cancel
    @account = current_account
    authorize @account, :update?

    subscription = @account.subscriptions.active.first

    if subscription.nil?
      flash[:alert] = "No active subscription found."
      redirect_to dashboard_path
      return
    end

    if Billing::Gateway.current.cancel_subscription(subscription)
      flash[:notice] = "Your subscription has been cancelled. You'll have access until #{subscription.current_period_end.strftime('%B %d, %Y')}."
    else
      flash[:alert] = "There was an error cancelling your subscription. Please contact support."
    end

    redirect_to account_settings_path
  end

  def billing_portal
    @account = current_account
    authorize @account, :update?

    portal_session = Billing::Gateway.current.create_billing_portal_session(
      @account,
      return_url: account_settings_url
    )

    redirect_to portal_session.url, allow_other_host: true
  end

  private

  def find_plan(plan_id)
    plans = Rails.application.config_for(:plans)['plans']
    plans.find { |p| p['id'] == plan_id }
  end
end