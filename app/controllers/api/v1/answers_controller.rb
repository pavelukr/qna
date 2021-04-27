module Api
  module V1
    class AnswersController < Api::BaseController
      before_action :find_question, only: :create

      def create
        authorize(@answer = @question.answers
                                     .create(answer_params.merge(user_id: current_resource_owner.id)))
        respond_with :api, :v1, @question, @answer
      end

      def index
        @answers = Answer.where(question_id: params[:question_id]).best_sort
        respond_with @answers
      end

      def show
        @answer = Answer.find(params[:id])
        respond_with @answer
      end

      private

      def find_question
        @question = Question.find(params[:question_id])
      end

      def answer_params
        params.require(:answer).permit(:body, :question_id)
      end
    end
  end
end
