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

  def count_voices
    all_voices = 0
    self.votes.each do |vote|
      all_voices += vote.opinion
    end
    all_voices
  end

  def find_vote(current_user)
    self.votes.each do |vote|
      if vote.user_id == current_user.id
        return vote
      end
    end
  end

  def check_for_user(current_user)
    self.votes.each do |vote|
      if vote.user_id == current_user.id
        return false
      end
    end
    true
  end
end
