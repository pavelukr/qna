class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user_check
  end

  def destroy?
    user_check && user.admin? || user.id == record.user_id
  end
end
