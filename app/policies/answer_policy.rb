class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user_check
  end

  def update?
    user_check && user.admin? || user == record.user
  end

  def destroy?
    user_check && user.admin? || user == record.user
  end

  def delete_attachment?
    user_check && user.admin? || user == record.user
  end

  def select_best?
    if user_check
      user.admin? || user == record.question.user
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
