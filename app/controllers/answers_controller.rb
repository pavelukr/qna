class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :find_question, except: [:show]
  before_action :find_answer, only: [:show, :destroy, :update, :edit]
  before_action :find_answer_vote, only: [:like, :dislike, :unvote, :create_comment, :delete_comment]
  after_action :perform, only: [:create]

  include Voted
  include Commented

  authorize_resource :question
  authorize_resource :answer, through: %i[question]
  authorize_resource :comment
  authorize_resource :vote
  authorize_resource :attachment


  def show
  end

  def select_best
    @answer = Answer.find(params[:answer_id])
    @answer.select_best!(@question, @answer) if current_user.creator_of(@question)
  end

  def edit
  end

  def delete_attachment
    @answer = Answer.find(params[:answer_id])
    @attachment = Attachment.find(params[:attachment_id])
    @attachment.destroy if current_user.creator_of(@answer)
    @answer.save
  end

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
    @answer.save
  end

  def destroy
    @answer.destroy if current_user.creator_of(@answer)
  end

  def update
    @answer.update(answer_params) if current_user.creator_of(@answer)
  end

  private

  def perform
    ActionCable.server.broadcast 'answers_channel', { answer: render_answer(current_user, @answer, @question) }
  end

  def render_answer(user, answer, question)
    ApplicationController.render_with_signed_in_user(user,
                                                     partial: 'answers/answer',
                                                     locals: { answer: answer, question: question })
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_answer_vote
    @instance = Answer.find(params[:answer_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, attachments_attributes: [:file, :_destroy])
  end
end
