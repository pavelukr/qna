class DailyMailerJob < ApplicationJob
  queue_as :default

  def perform(questions)
    User.all.each do |user|
      UserMailer.new_questions_list(user, questions)
    end
  end
end
