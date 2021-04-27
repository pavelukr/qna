class SearchesController < ApplicationController

  def search_question
    questions = params[:questions]
    @results_question = Question.search(questions) unless questions == '' || questions.nil?
  end

  def search_comment
    comments = params[:comments]
    @results_comment = Comment.search(comments) unless comments == '' || comments.nil?
  end

  def search_answer
    answers = params[:answers]
    @results_answer = Answer.search(answers) unless answers == '' || answers.nil?
  end
end
