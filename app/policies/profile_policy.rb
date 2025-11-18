class ProfilePolicy < ApplicationPolicy
  def show?
    user.present? && record == user
  end

  def edit?
    show?
  end

  def update?
    show?
  end
end
