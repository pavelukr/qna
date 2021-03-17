class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :find_question, except: [:show]
  before_action :find_answer, only: [:show, :destroy, :update, :edit]

  def show
  end

  def select_best
    @answer = Answer.find(params[:answer_id])
    @answer.select_best!(@question, @answer)
  end

  def edit
  end

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer.destroy
  end

  def update
    @answer.update(answer_params)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
