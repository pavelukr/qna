require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :answers }
  it { should have_many :questions }

  describe '.find_for_oauth' do
    before { @user = create(:user) }

    context 'user already has authorization' do
      before { @auth = OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

      it 'returns the user' do
        @user.authorizations.create(provider: 'github', uid: '123456')
        expect(User.find_for_oauth(@auth)).to eq @user
      end
    end

    context 'user has no authorization' do
      context 'user already exists' do
        before { @auth = OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: @user.email }) }

        it 'does not create new user' do
          expect { User.find_for_oauth(@auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(@auth) }.to change(@user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          user = User.find_for_oauth(@auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq @auth.provider
          expect(authorization.uid).to eq @auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(@auth)).to eq @user
        end
      end
    end

    context 'user does not exist' do
      before { @auth = OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'new@user.com' }) }
      it 'creates new user' do
        expect { User.find_for_oauth(@auth) }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(User.find_for_oauth(@auth)).to be_a(User)
      end
      it 'fills user email' do

        user = User.find_for_oauth(@auth)
        expect(user.email).to eq @auth.info.email
      end
      it 'creates authorization for user' do
        user = User.find_for_oauth(@auth)
        expect(user.authorizations).to_not be_empty
      end
      it 'creates authorization with provider and uid' do
        authorization = User.find_for_oauth(@auth).authorizations.first
        expect(authorization.provider).to eq @auth.provider
        expect(authorization.uid).to eq @auth.uid
      end
    end
  end

  describe '.send_daily' do
    let(:users) { create_list(:user, 2) }
    let(:questions) { create_list(:question, 2, { user: User.new }) }

    it 'should send daily digest to all users' do
      users.each { |user| expect(UserMailer).to receive(:new_questions_list).with(user, questions).and_call_original }
      User.send_daily
    end
  end
end
