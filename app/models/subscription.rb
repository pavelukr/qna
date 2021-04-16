class Subscription < ApplicationRecord
  validates :user_id, uniqueness: { scope: :question_id }

  private

  def self.exists(current_user, question)
    Subscription.find_by question_id: question.id, user_id: current_user.id
  end

end
