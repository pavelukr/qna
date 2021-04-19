class DailyMailerJob < ApplicationJob
  queue_as :default

  def perform
    User.send_daily
  end
end
#Sidekiq.redis(&:flushdb)