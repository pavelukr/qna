class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create_comment?
    user_check
  end

  def delete_comment?
    if user_check
      user.admin? || user.id == record.user_id
    end
  end
end
