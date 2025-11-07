module HasAuditTrail
  extend ActiveSupport::Concern

  included do
    has_many :audit_events, as: :auditable, dependent: :destroy

    after_create :log_creation
    after_update :log_update
    after_destroy :log_destruction
  end

  def log_event(action, metadata = {})
    audit_events.create!(
      account: Current.account,
      user: Current.user,
      action: action,
      metadata: metadata.merge(default_audit_metadata),
      ip_address: Current.ip_address,
      user_agent: Current.user_agent
    )
  end

  private

  def log_creation
    return if skip_audit?

    log_event('created', changes_for_audit)
  end

  def log_update
    return if skip_audit? || !saved_changes?

    log_event('updated', changes_for_audit)
  end

  def log_destruction
    return if skip_audit?

    log_event('destroyed', attributes_for_audit)
  end

  def changes_for_audit
    saved_changes.except(*audit_excluded_attributes)
  end

  def attributes_for_audit
    attributes.except(*audit_excluded_attributes.map(&:to_s))
  end

  def default_audit_metadata
    {
      model_class: self.class.name,
      model_id: id,
      timestamp: Time.current
    }
  end

  def audit_excluded_attributes
    %w[created_at updated_at id encrypted_password reset_password_token]
  end

  def skip_audit?
    Current.skip_audit || self.class.skip_audit_for_current_request
  end

  class_methods do
    attr_accessor :skip_audit_for_current_request

    def without_audit
      self.skip_audit_for_current_request = true
      yield
    ensure
      self.skip_audit_for_current_request = false
    end
  end
end