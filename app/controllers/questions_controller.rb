class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :find_question_vote, only: [:like, :dislike, :unvote]

  include Voted

  def new
    @question = Question.new
    @question.attachments.build
  end

  def delete_attachment
    @question = Question.find(params[:question_id])
    @attachment = Attachment.find(params[:attachment_id])
    @attachment.destroy if current_user.creator_of(@question)
    @question.save
    redirect_to @question
  end

  def index
    @question = Question.new
    @question.attachments.build
    @questions = Question.all
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      ActionCable.server.broadcast('questions_channel', { content: @question })
    else
      render :new
    end
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def edit
  end

  def update
    @question.update(question_params) if current_user.creator_of(@question)
  end

  def destroy
    @question.destroy if current_user.creator_of(@question)
    redirect_to questions_path
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def find_question_vote
    @instance = Question.find(params[:question_id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy])
  end
end
