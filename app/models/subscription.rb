class Subscription < ApplicationRecord
  belongs_to :account

  # Scopes
  scope :active, -> { where(status: ['active', 'trialing']) }
  scope :canceled, -> { where(status: 'canceled') }
  scope :past_due, -> { where(status: 'past_due') }

  # Validations
  validates :stripe_subscription_id, presence: true, uniqueness: true
  validates :status, presence: true

  def active?
    status.in?(['active', 'trialing'])
  end

  def canceled?
    status == 'canceled'
  end

  def trialing?
    status == 'trialing'
  end

  def past_due?
    status == 'past_due'
  end

  def days_until_renewal
    return nil unless current_period_end

    (current_period_end.to_date - Date.today).to_i
  end

  def cancel_at_period_end?
    cancel_at.present? && !canceled?
  end
end