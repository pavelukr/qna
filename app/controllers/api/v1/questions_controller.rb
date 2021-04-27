module Api
  module V1
    class QuestionsController < Api::BaseController

      def create
        respond_with(authorize(@question = Question
          .create(question_params.merge(user_id: current_resource_owner.id))))
      end

      def index
        @questions = Question.all
        respond_with @questions
      end

      def show
        @question = Question.find(params[:id])
        respond_with @question
      end

      private

      def question_params
        params.require(:question).permit(:title, :body)
      end
    end
  end
end
