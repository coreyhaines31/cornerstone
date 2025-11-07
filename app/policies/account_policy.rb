class AccountPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:memberships).where(memberships: { user_id: user.id, accepted_at: !nil })
    end
  end

  def index?
    user.present?
  end

  def show?
    user_is_member?
  end

  def create?
    user.present?
  end

  def update?
    user_is_owner? || user_is_admin?
  end

  def destroy?
    user_is_owner? && not_last_account?
  end

  def switch?
    user_is_member?
  end

  private

  def user_is_member?
    user.present? && user.member_of?(record)
  end

  def user_is_admin?
    user.present? && user.admin_of?(record)
  end

  def user_is_owner?
    user.present? && user.owner_of?(record)
  end

  def not_last_account?
    user.accounts.count > 1
  end
end