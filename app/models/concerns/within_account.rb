module WithinAccount
  extend ActiveSupport::Concern

  included do
    belongs_to :account
    default_scope -> { where(account: Current.account) if Current.account }

    validates :account, presence: true

    before_validation :set_current_account, on: :create
  end

  class_methods do
    def within_account(account)
      unscoped.where(account: account)
    end

    def for_any_account
      unscoped
    end

    def for_accounts(account_ids)
      unscoped.where(account_id: account_ids)
    end
  end

  private

  def set_current_account
    self.account ||= Current.account
  end
end