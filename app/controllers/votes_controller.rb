class VotesController < ApplicationController
  def destroy
    @question = Question.find(params[:question_id])
    @vote = Vote.find(params[:id])
    respond_to do |format|
      if @vote.destroy
        @question.save
        format.json { render json: @question.count_voices }
      else
        format.json { render json: @instance.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end
end