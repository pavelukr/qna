module Commented
  extend ActiveSupport::Concern

  def create_comment
    @comment = authorize @instance.comments.create(view: params[:view], user_id: current_user.id)
    ActionCable.server.broadcast 'comments_channel',
                                 { content: [@comment, { instance_id: @instance.id }] }
  end

  def delete_comment
    @comment = Comment.find_by user_id: current_user.id, commentable: @instance
    authorize @comment
    @comment.destroy
    redirect_back(fallback_location: root_path)
  end
end
