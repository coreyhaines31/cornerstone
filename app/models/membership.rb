class Membership < ApplicationRecord
  ROLES = %w[owner admin member].freeze

  # Associations
  belongs_to :account
  belongs_to :user, optional: true
  belongs_to :invited_by, class_name: 'User', optional: true

  # Validations
  validates :role, presence: true, inclusion: { in: ROLES }
  validates :user_id, uniqueness: { scope: :account_id }, if: :user_id?
  validates :email, presence: true, unless: :user_id?
  validate :at_least_one_owner_per_account, on: :destroy

  # Scopes
  scope :owners, -> { where(role: 'owner') }
  scope :admins, -> { where(role: 'admin') }
  scope :members, -> { where(role: 'member') }
  scope :accepted, -> { where.not(accepted_at: nil) }
  scope :pending, -> { where(accepted_at: nil) }

  # Callbacks
  after_create :send_invitation_email, if: :pending?
  before_destroy :prevent_last_owner_removal

  def owner?
    role == 'owner'
  end

  def admin?
    role == 'admin'
  end

  def member?
    role == 'member'
  end

  def pending?
    accepted_at.nil?
  end

  def accepted?
    accepted_at.present?
  end

  def accept!(accepting_user)
    return false if accepted?

    update!(
      user: accepting_user,
      accepted_at: Time.current
    )

    # Log acceptance
    account.audit_events.create!(
      user: accepting_user,
      action: 'membership_accepted',
      metadata: { membership_id: id, role: role }
    )

    # Send notification to account owner
    AccountMailer.member_joined(self).deliver_later

    true
  end

  def decline!
    return false if accepted?

    destroy

    # Send notification
    AccountMailer.invitation_declined(self).deliver_later if invited_by

    true
  end

  def can_manage_members?
    owner? || admin?
  end

  def can_manage_billing?
    owner?
  end

  def can_manage_settings?
    owner? || admin?
  end

  def invitation_token
    @invitation_token ||= generate_invitation_token
  end

  def self.find_by_invitation_token(token)
    memberships = pending.where('created_at > ?', 7.days.ago)
    memberships.find { |m| m.valid_invitation_token?(token) }
  end

  def valid_invitation_token?(token)
    return false if accepted?
    return false if created_at < 7.days.ago

    # Generate expected token
    expected_token = generate_invitation_token
    ActiveSupport::SecurityUtils.secure_compare(token, expected_token)
  end

  private

  def send_invitation_email
    AccountMailer.invitation(self).deliver_later
  end

  def at_least_one_owner_per_account
    if owner? && account.memberships.owners.count <= 1
      errors.add(:base, "Cannot remove the last owner of an account")
    end
  end

  def prevent_last_owner_removal
    if owner? && account.memberships.owners.count <= 1
      errors.add(:base, "Cannot remove the last owner of an account")
      throw :abort
    end
  end

  def generate_invitation_token
    data = "#{id}-#{account_id}-#{created_at.to_i}"
    Digest::SHA256.hexdigest(data)
  end
end