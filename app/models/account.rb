class Account < ApplicationRecord
  # Associations
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :subscriptions, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :audit_events, dependent: :destroy
  has_many :webhook_events, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }

  # Scopes
  scope :active, -> { where(subscription_status: ['active', 'trialing']) }
  scope :trialing, -> { where(subscription_status: 'trialing') }
  scope :past_due, -> { where(subscription_status: 'past_due') }
  scope :canceled, -> { where(subscription_status: 'canceled') }

  # Callbacks
  before_validation :generate_slug, on: :create

  # Store settings as JSON
  serialize :settings, JSON

  def owner
    memberships.owners.first&.user
  end

  def owners
    memberships.owners.map(&:user)
  end

  def admins
    memberships.where(role: ['owner', 'admin']).map(&:user)
  end

  def members
    memberships.accepted.map(&:user)
  end

  def invite_user(email:, role: 'member', invited_by:)
    user = User.find_by(email: email)

    if user.nil?
      # Create invitation for non-existent user
      membership = memberships.create!(
        email: email,
        role: role,
        invited_by: invited_by
      )

      # Send invitation email
      AccountMailer.invitation(membership).deliver_later
    else
      # User exists, create membership
      membership = memberships.create!(
        user: user,
        role: role,
        invited_by: invited_by
      )

      # Send invitation email
      AccountMailer.member_invitation(membership).deliver_later
    end

    membership
  end

  def remove_user(user)
    membership = memberships.find_by(user: user)
    return false unless membership

    # Prevent removing the last owner
    if membership.owner? && memberships.owners.count == 1
      return false
    end

    membership.destroy
  end

  def subscribed?
    subscription_status.in?(['active', 'trialing'])
  end

  def trial?
    subscription_status == 'trialing'
  end

  def subscription
    subscriptions.active.first
  end

  def plan
    return nil unless subscription

    plans = Rails.application.config_for(:plans)['plans']
    plans.find { |p| p['stripe_price_id'] == subscription.stripe_price_id }
  end

  def plan_name
    plan&.dig('name') || 'Free'
  end

  def can_access_feature?(feature)
    return false unless plan

    plan['features']&.key?(feature.to_s)
  end

  def feature_limit(feature)
    return 0 unless plan

    limit = plan['features']&.dig(feature.to_s)
    return Float::INFINITY if limit == 'unlimited'

    limit.to_i
  end

  def within_limit?(feature, current_count)
    limit = feature_limit(feature)
    return true if limit == Float::INFINITY

    current_count < limit
  end

  def stripe_customer
    return nil unless stripe_customer_id

    @stripe_customer ||= Stripe::Customer.retrieve(stripe_customer_id)
  end

  def create_stripe_customer!
    return stripe_customer if stripe_customer_id.present?

    customer = Billing::Gateway.current.create_customer(owner)
    update!(stripe_customer_id: customer.id)
    customer
  end

  private

  def generate_slug
    return if slug.present?

    base_slug = name.parameterize
    candidate_slug = base_slug
    counter = 1

    while Account.exists?(slug: candidate_slug)
      candidate_slug = "#{base_slug}-#{counter}"
      counter += 1
    end

    self.slug = candidate_slug
  end
end