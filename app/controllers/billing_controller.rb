class BillingController < ApplicationController
  layout "inertia"

  def show
    account = current_account
    authorize account, :show?, policy_class: AccountPolicy

    render inertia: "Billing", props: {
      account: account_payload(account),
      user: user_payload,
      plans: plans_payload,
      payment_methods: payment_methods_payload,
      invoices: invoices_payload(account)
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

  def plans_payload
    [
      { name: "Starter", price: "$0", period: "mo", features: ["Up to 3 members", "Community support"], recommended: false },
      { name: "Growth", price: "$29", period: "mo", features: ["Up to 25 members", "Usage analytics", "Priority email support"], recommended: true },
      { name: "Scale", price: "$99", period: "mo", features: ["Unlimited members", "SSO/SCIM", "Audit logs"], recommended: false }
    ]
  end

  def payment_methods_payload
    [
      { brand: "Visa", last4: "4242", expiry: "12/26", primary: true },
      { brand: "Mastercard", last4: "1881", expiry: "05/27", primary: false }
    ]
  end

  def invoices_payload(account)
    [
      { id: "INV-001", amount: "$29.00", period: "Jan 2025", status: "paid", url: "#" },
      { id: "INV-002", amount: "$29.00", period: "Feb 2025", status: "open", url: "#" }
    ]
  end
end
