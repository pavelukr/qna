require 'rails_helper'

RSpec.describe DailyMailerJob, type: :job do
  it 'sends daily digest' do
    expect(User).to receive(:send_daily)
    DailyMailerJob.perform_now
  end
end
