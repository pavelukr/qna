class Answer < ApplicationRecord
  validates :body, presence: true
  belongs_to :question
  belongs_to :user
  scope :best_sort, -> { order(best: :desc) }

  def select_best!(question, answer)
    question.answers.map do |answer_question|
      if answer_question == answer
        answer_question.update(best: true)
      else
        answer_question.update(best: false)
      end
    end
  end
end
