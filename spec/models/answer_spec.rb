require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }

  it { should belong_to :question }
  it { should belong_to :user }

  describe '.send_mail_answer' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:subscription) { create(:subscription, user_id: user.id, question_id: question.id) }
    subject { build(:answer, user: user, question: question) }

    it 'should send mail tou users about new answer' do
      expect(UserMailer).to receive(:new_answer).with(user, subject, question).and_call_original
      subject.save!
    end
  end
end
