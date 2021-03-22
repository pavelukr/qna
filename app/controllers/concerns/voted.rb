module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_vote, only: :unvote
    before_action :instance_class_name, only: [:like, :dislike]
  end

  def like
    @vote = @instance.votes.build(opinion: +1, user_id: current_user)

=begin
    respond_to do |format|
      if @vote.save
        format.json { render json: @answer }
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
=end
  end

  def dislike
    @vote = @class_name.find(params[:id]).votes.build(opinion: -1, user: current_user)

=begin
    respond_to do |format|
      if @vote.save
        format.json { render json: @answer }
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
=end
  end

  def unvote
    @vote.destroy if current_user.creator_of(@vote)

=begin
    respond_to do |format|
      if @vote.save
        format.json { render json: @answer }
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
=end
  end

  private

  def find_vote
    @vote = Vote.find(params[:id])
  end

  def instance_class_name
    @instance_class_name = controller_name.classify.constantize
  end
end
