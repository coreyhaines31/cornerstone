class Webhooks::StripeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      render json: { error: 'Invalid payload' }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: 'Invalid signature' }, status: 400
      return
    end

    # Handle the event
    case event.type
    when 'customer.created'
      handle_customer_created(event)
    when 'customer.subscription.created'
      handle_subscription_created(event)
    when 'customer.subscription.updated'
      handle_subscription_updated(event)
    when 'customer.subscription.deleted'
      handle_subscription_deleted(event)
    when 'invoice.payment_succeeded'
      handle_payment_succeeded(event)
    when 'invoice.payment_failed'
      handle_payment_failed(event)
    when 'checkout.session.completed'
      handle_checkout_completed(event)
    when 'customer.subscription.trial_will_end'
      handle_trial_ending(event)
    else
      Rails.logger.info "Unhandled Stripe event type: #{event.type}"
    end

    render json: { status: 'success' }
  end

  private

  def handle_customer_created(event)
    customer = event.data.object

    # Find user by email
    user = User.find_by(email: customer.email)
    return unless user

    # Update user's stripe_customer_id
    user.update!(stripe_customer_id: customer.id)

    # Log the event
    create_webhook_event(event, user: user)
  end

  def handle_subscription_created(event)
    subscription = event.data.object

    # Find account by stripe_customer_id
    account = Account.joins(:owner).find_by(users: { stripe_customer_id: subscription.customer })
    return unless account

    # Create or update subscription record
    account.subscriptions.find_or_create_by(stripe_subscription_id: subscription.id) do |sub|
      sub.status = subscription.status
      sub.current_period_start = Time.at(subscription.current_period_start)
      sub.current_period_end = Time.at(subscription.current_period_end)
      sub.cancel_at = subscription.cancel_at ? Time.at(subscription.cancel_at) : nil
      sub.canceled_at = subscription.canceled_at ? Time.at(subscription.canceled_at) : nil
      sub.trial_end = subscription.trial_end ? Time.at(subscription.trial_end) : nil
      sub.stripe_price_id = subscription.items.data.first.price.id
      sub.quantity = subscription.items.data.first.quantity
    end

    # Update account's subscription status
    account.update!(
      subscription_status: subscription.status,
      plan_name: get_plan_name_from_price_id(subscription.items.data.first.price.id)
    )

    # Send confirmation email
    AccountMailer.subscription_created(account).deliver_later

    create_webhook_event(event, account: account)
  end

  def handle_subscription_updated(event)
    subscription = event.data.object

    # Find subscription record
    sub = Subscription.find_by(stripe_subscription_id: subscription.id)
    return unless sub

    # Update subscription
    sub.update!(
      status: subscription.status,
      current_period_start: Time.at(subscription.current_period_start),
      current_period_end: Time.at(subscription.current_period_end),
      cancel_at: subscription.cancel_at ? Time.at(subscription.cancel_at) : nil,
      canceled_at: subscription.canceled_at ? Time.at(subscription.canceled_at) : nil,
      trial_end: subscription.trial_end ? Time.at(subscription.trial_end) : nil
    )

    # Update account
    sub.account.update!(
      subscription_status: subscription.status,
      plan_name: get_plan_name_from_price_id(subscription.items.data.first.price.id)
    )

    create_webhook_event(event, account: sub.account)
  end

  def handle_subscription_deleted(event)
    subscription = event.data.object

    # Find subscription record
    sub = Subscription.find_by(stripe_subscription_id: subscription.id)
    return unless sub

    # Update subscription status
    sub.update!(status: 'canceled', ended_at: Time.current)

    # Update account
    sub.account.update!(
      subscription_status: 'canceled',
      plan_name: 'free'
    )

    # Send cancellation email
    AccountMailer.subscription_canceled(sub.account).deliver_later

    create_webhook_event(event, account: sub.account)
  end

  def handle_payment_succeeded(event)
    invoice = event.data.object

    # Find account
    account = Account.joins(:owner).find_by(users: { stripe_customer_id: invoice.customer })
    return unless account

    # Create payment record
    Payment.create!(
      account: account,
      amount: invoice.amount_paid / 100.0,
      currency: invoice.currency,
      status: 'succeeded',
      stripe_invoice_id: invoice.id,
      stripe_payment_intent_id: invoice.payment_intent,
      description: invoice.lines.data.first.description,
      paid_at: Time.at(invoice.status_transitions.paid_at)
    )

    # Send receipt email
    AccountMailer.payment_received(account, invoice).deliver_later

    create_webhook_event(event, account: account)
  end

  def handle_payment_failed(event)
    invoice = event.data.object

    # Find account
    account = Account.joins(:owner).find_by(users: { stripe_customer_id: invoice.customer })
    return unless account

    # Create failed payment record
    Payment.create!(
      account: account,
      amount: invoice.amount_due / 100.0,
      currency: invoice.currency,
      status: 'failed',
      stripe_invoice_id: invoice.id,
      description: invoice.lines.data.first.description,
      failure_reason: invoice.last_payment_error&.message
    )

    # Send payment failed email
    AccountMailer.payment_failed(account, invoice).deliver_later

    # Update subscription status if needed
    if invoice.subscription
      account.update!(subscription_status: 'past_due')
    end

    create_webhook_event(event, account: account)
  end

  def handle_checkout_completed(event)
    session = event.data.object

    # Find account by session metadata
    account_id = session.metadata.account_id
    account = Account.find_by(id: account_id)
    return unless account

    # Update subscription info from the session
    if session.subscription
      subscription = Stripe::Subscription.retrieve(session.subscription)

      account.subscriptions.find_or_create_by(stripe_subscription_id: subscription.id) do |sub|
        sub.status = subscription.status
        sub.stripe_price_id = subscription.items.data.first.price.id
      end

      account.update!(
        stripe_customer_id: session.customer,
        subscription_status: subscription.status,
        plan_name: get_plan_name_from_price_id(subscription.items.data.first.price.id)
      )
    end

    # Send welcome email
    AccountMailer.checkout_completed(account).deliver_later

    create_webhook_event(event, account: account)
  end

  def handle_trial_ending(event)
    subscription = event.data.object

    # Find subscription
    sub = Subscription.find_by(stripe_subscription_id: subscription.id)
    return unless sub

    # Send trial ending email (3 days before)
    AccountMailer.trial_ending(sub.account).deliver_later

    create_webhook_event(event, account: sub.account)
  end

  def get_plan_name_from_price_id(price_id)
    plans = Rails.application.config_for(:plans)['plans']
    plan = plans.find { |p| p['stripe_price_id'] == price_id }
    plan&.dig('name') || 'Unknown'
  end

  def create_webhook_event(stripe_event, account: nil, user: nil)
    WebhookEvent.create!(
      provider: 'stripe',
      event_type: stripe_event.type,
      event_id: stripe_event.id,
      payload: stripe_event.to_json,
      account: account,
      user: user,
      processed_at: Time.current
    )
  end
end