class Answer < ApplicationRecord
  validates :body, presence: true
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable
  has_many :votes, as: :votable
  has_many :comments, as: :commentable
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  scope :best_sort, -> { order(best: :desc) }
  after_create :send_mail_answer

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
    votes.each do |vote|
      all_voices += vote.opinion
    end
    all_voices
  end

  def check_for_user(current_user)
    votes.each do |vote|
      return false if vote.user_id == current_user.id
    end
    true
  end

  def send_mail_answer
    users_ids = []
    subscriptions = Subscription.where(question_id: question.id)
    subscriptions.each do |subscription|
      users_ids.push(subscription.user_id)
    end
    users_ids.each do |user_id|
      UserMailer.new_answer(User.find(user_id), self, question).deliver_later
    end
  end

  private

  def find_users
    users_ids = []
    subscriptions = Subscription.where(question_id: question.id)
    subscriptions.each do |subscription|
      users_ids.push(subscription.user_id)
    end
    users_ids
  end
end
