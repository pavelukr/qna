class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user_check
  end

  def update?
    if user_check
      user.admin? || user == record.user
    end
  end

  def destroy?
    if user_check
      user.admin? || user == record.user
    end
  end

  def delete_attachment?
    if user_check
      user.admin? || user == record.user
    end
  end

  def like?
    if user_check
      user.admin? || user != record.user
    end
  end

  def dislike?
    if user_check
      user.admin? || user != record.user
    end
  end

  def unvote?
    if user_check
      user.admin? || user != record.user
    end
  end
end
