class DashboardPolicy < ApplicationPolicy
  def show?
    user.present? && user.member_of?(record)
  end
end