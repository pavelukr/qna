class AnswersController < ApplicationController
  before_action :find_question, only: [:create, :new]
  before_action :find_answer, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.build(answer_params)
    if @answer.save
      redirect_to @question, note: 'Answer successfully send!'
    else
      redirect_to new_question_answer_path(@question)
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_answer_path
    else
      render :edit
    end
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
