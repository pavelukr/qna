class QuestionsController < ApplicationController
  before_action :find_question, only: [:show, :edit, :update]

  def new
    @question = Question.new
  end

  def index
    @questions = Question.all
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
