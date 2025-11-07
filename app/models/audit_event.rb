class AuditEvent < ApplicationRecord
  belongs_to :account, optional: true
  belongs_to :user, optional: true
  belongs_to :auditable, polymorphic: true, optional: true

  # Serialize metadata
  serialize :metadata, JSON

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }
  scope :for_account, ->(account) { where(account: account) }
  scope :for_action, ->(action) { where(action: action) }

  # Validations
  validates :action, presence: true

  def self.log(action, user: nil, account: nil, auditable: nil, metadata: {})
    create!(
      action: action,
      user: user || Current.user,
      account: account || Current.account,
      auditable: auditable,
      metadata: metadata,
      ip_address: Current.ip_address,
      user_agent: Current.user_agent
    )
  end

  def description
    case action
    when 'created'
      "#{user&.name} created #{auditable_type} ##{auditable_id}"
    when 'updated'
      "#{user&.name} updated #{auditable_type} ##{auditable_id}"
    when 'destroyed'
      "#{user&.name} deleted #{auditable_type} ##{auditable_id}"
    when 'account_switched'
      "#{user&.name} switched to this account"
    when 'membership_accepted'
      "#{user&.name} joined the account"
    when 'subscription_created'
      "Subscription created"
    when 'payment_succeeded'
      "Payment processed successfully"
    else
      "#{user&.name} performed #{action}"
    end
  end
end