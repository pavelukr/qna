class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :find_question_vote, only: [:like, :dislike, :unvote, :create_comment, :delete_comment]
  after_action :perform, only: [:create]

  include Voted
  include Commented

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

  def perform
    ActionCable.server.broadcast 'questions_channel', { question: render_question(@question) }
  end

  def render_question(question)
    warden = request.env["warden"]
    ApplicationController.renderer.instance_variable_set(:@env, {"HTTP_HOST" => "localhost:3000",
                                                                 "HTTPS" => "off",
                                                                 "REQUEST_METHOD" => "GET",
                                                                 "SCRIPT_NAME" => "",
                                                                 "warden" => warden})
    ApplicationController.renderer.render(partial: 'questions/question', locals: { question: question })
  end

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
