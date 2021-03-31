module Commented
  extend ActiveSupport::Concern

  def create_comment
    if user_signed_in?
      @comment = @instance.comments.create(view: params[:view], user_id: current_user.id)
      ActionCable.server.broadcast 'comments_channel',
                                   { content: [@comment, { instance_id: @instance.id }] }
    end
  end

  def delete_comment
    if user_signed_in?
      @comment = Comment.where(user_id: current_user.id, commentable: @instance).first
      @comment.destroy
      redirect_back(fallback_location: root_path)
    end
  end
end
