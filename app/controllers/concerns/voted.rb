module Voted
  extend ActiveSupport::Concern

  included do
    before_action :instance_class_name, only: [:like, :dislike]
  end

  def like
    @vote = @instance.votes.build(opinion: +1, user_id: current_user.id)

    respond_to do |format|
      if @vote.save
        format.json { render json: @instance.count_voices }
      else
        format.json { render json: @instance.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def dislike
    @vote = @instance.votes.build(opinion: -1, user_id: current_user.id)

    respond_to do |format|
      if @vote.save
        format.json { render json: @instance.count_voices }
      else
        format.json { render json: @instance.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_vote
    @vote = Vote.find(params[:vote_id])
  end

  def instance_class_name
    @instance_class_name = controller_name.classify.constantize
  end
end
