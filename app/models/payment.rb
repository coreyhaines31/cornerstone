class Payment < ApplicationRecord
  belongs_to :account

  # Scopes
  scope :succeeded, -> { where(status: 'succeeded') }
  scope :failed, -> { where(status: 'failed') }
  scope :recent, -> { order(created_at: :desc) }

  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :status, presence: true

  def succeeded?
    status == 'succeeded'
  end

  def failed?
    status == 'failed'
  end

  def formatted_amount
    "#{currency.upcase} #{sprintf('%.2f', amount)}"
  end
end