class Answer < ApplicationRecord
  validates :body, presence: true
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable
  has_many :votes, as: :votable
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
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
