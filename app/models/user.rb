class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable,
         :timeoutable, timeout_in: 30.minutes

  # OTP for two-factor authentication
  has_one_time_password(encrypted: true)

  # Associations
  has_many :memberships, dependent: :destroy
  has_many :accounts, through: :memberships
  has_many :audit_events, dependent: :nullify
  has_many :ai_conversations, dependent: :destroy
  has_one_attached :avatar

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # Scopes
  scope :admins, -> { where(admin: true) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  # Callbacks
  before_validation :normalize_email
  after_create :send_welcome_email

  # Instance methods
  def name
    "#{first_name} #{last_name}".strip
  end

  def initials
    [first_name&.first, last_name&.first].compact.join.upcase
  end

  def membership_for(account)
    memberships.find_by(account: account)
  end

  def owner_of?(account)
    membership_for(account)&.owner?
  end

  def admin_of?(account)
    membership = membership_for(account)
    membership&.owner? || membership&.admin?
  end

  def member_of?(account)
    memberships.exists?(account: account, accepted_at: !nil)
  end

  def pending_invitations
    memberships.where(accepted_at: nil)
  end

  def otp_enabled?
    otp_required_for_login?
  end

  def enable_otp!
    self.otp_secret = User.generate_otp_secret
    self.otp_required_for_login = true
    save!
  end

  def disable_otp!
    self.otp_required_for_login = false
    self.consumed_timestep = nil
    save!
  end

  def otp_qr_code
    require 'rqrcode'
    issuer = Rails.application.config.application_name
    label = "#{issuer}:#{email}"
    qr_code = RQRCode::QRCode.new(otp_provisioning_uri(label, issuer: issuer))
    qr_code.as_svg(module_size: 4)
  end

  def generate_magic_link_token
    token = SecureRandom.urlsafe_base64(32)
    self.login_token = Digest::SHA256.hexdigest(token)
    self.login_token_valid_until = 15.minutes.from_now
    save!
    token
  end

  def valid_magic_link_token?(token)
    return false if login_token.blank? || login_token_valid_until.blank?
    return false if Time.current > login_token_valid_until

    hashed_token = Digest::SHA256.hexdigest(token)
    ActiveSupport::SecurityUtils.secure_compare(login_token, hashed_token)
  end

  def clear_magic_link_token!
    update(login_token: nil, login_token_valid_until: nil)
  end

  def subscribed?
    accounts.any? { |account| account.subscribed? }
  end

  def subscription_status
    accounts.first&.subscription_status || 'none'
  end

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver_later
  end
end