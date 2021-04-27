module Commented
  extend ActiveSupport::Concern

  def create_comment
    if user_sign_in?
      @comment = @instance.comments.create(view: view, user_id: current_user.id)
    end
  end

  def delete_comment
    if user_sign_in?
      @comment = Comment.where(user_id: current_user.id, votable: @instance).first
      @comment.destroy
    end
  end
end
