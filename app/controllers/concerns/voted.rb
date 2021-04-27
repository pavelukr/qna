module Voted
  extend ActiveSupport::Concern

  def like
    authorize @instance
    respond_to do |format|
      @vote = @instance.votes.create(opinion: +1, user_id: current_user.id)
      format.json { render json: @instance.count_voices }
    end
  end

  def dislike
    authorize @instance
    respond_to do |format|
      @vote = @instance.votes.create(opinion: -1, user_id: current_user.id)
      format.json { render json: @instance.count_voices }
    end
  end

  def unvote
    authorize @instance

    @vote = Vote.find_by user_id: current_user.id, votable: @instance

    respond_to do |format|
      if @vote.destroy
        format.json { render json: @instance.count_voices }
      else
        format.json { render json: @instance.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end
end
