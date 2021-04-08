class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy]
  before_action :find_question_vote, only: %i[like dislike unvote create_comment delete_comment]
  before_action :build_answer, only: :show
  before_action :find_question_attachment, only: :delete_attachment
  before_action :find_attachment, only: :delete_attachment
  after_action :perform, only: [:create]

  include Voted
  include Commented

  respond_to :js, only: %i[update edit]

  authorize_resource :question
  authorize_resource :answer, through: %i[question]
  authorize_resource :comment
  authorize_resource :vote
  authorize_resource :attachment

  def new
    @question = Question.new
  end

  def delete_attachment
    @attachment.destroy if current_user.creator_of(@question)
    respond_with @question
  end

  def index
    @questions = Question.all
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user_id: current_user.id)))
  end

  def show
    respond_with @question
  end

  def edit
  end

  def update
    @question.update(question_params) if current_user.creator_of(@question)
  end

  def destroy
    @question.destroy if current_user.creator_of(@question)
    redirect_back(fallback_location: root_path)
  end

  private

  def perform
    ActionCable.server.broadcast 'questions_channel', { question: render_question(current_user, @question) }
  end

  def render_question(user, question)
    ApplicationController.render_with_signed_in_user(user,
                                                     partial: 'questions/question',
                                                     locals: { question: question })
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def find_question_attachment
    @question = Question.find(params[:question_id])
  end

  def find_question_vote
    @instance = Question.find(params[:question_id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: %i[file _destroy])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def find_attachment
    @attachment = Attachment.find(params[:attachment_id])
  end

end
