class Question < ApplicationRecord
  validates :title, :body, presence: true
  has_many :answers
  has_many :attachments, as: :attachable
  has_many :votes, as: :votable
  belongs_to :user
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

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
