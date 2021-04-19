class Question < ApplicationRecord
  validates :title, :body, presence: true
  has_many :answers
  has_many :attachments, as: :attachable
  has_many :votes, as: :votable
  has_many :comments, as: :commentable
  has_many :subscriptions
  belongs_to :user
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def count_voices
    all_voices = 0
    self.votes.each do |vote|
      all_voices += vote.opinion
    end
    all_voices
  end

  def check_for_user(current_user)
    self.votes.each do |vote|
      return false if vote.user_id == current_user.id
    end
    true
  end

  def self.list_of_questions
    questions = []
    now = DateTime.now.to_i
    find_each.each do |question|
      time_diff = (now - question.created_at.to_i) / 86_400
      questions.push(question) if time_diff < 1
    end
    questions
  end
end
