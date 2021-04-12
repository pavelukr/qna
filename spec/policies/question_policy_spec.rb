require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  subject { described_class }

  let(:user) { create(:user) }

  permissions :create? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:question,
                                                              { user: user }))
    end

    it 'grant access if user is signed in' do
      expect(subject).to permit(User.new(admin: false), create(:question,
                                                               { user: user }))
    end

    it 'denies access if user is not signed in' do
      expect(subject).not_to permit(nil, create(:question,
                                                { user: user }))
    end
  end

  permissions :update? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:question,
                                                              { user: user }))
    end

    it 'grant access if user is author' do
      expect(subject).to permit(user, create(:question,
                                             { user: user }))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(User.new, create(:question,
                                                     { user: user }))
    end

    it 'denies access if user is not signed in' do
      expect(subject).not_to permit(nil, create(:question,
                                                { user: user }))
    end
  end

  permissions :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:question,
                                                              { user: user }))
    end

    it 'grant access if user is author' do
      expect(subject).to permit(user, create(:question,
                                             { user: user }))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(User.new, create(:question,
                                                     { user: user }))
    end

    it 'denies access if user is not signed in' do
      expect(subject).not_to permit(nil, create(:question,
                                                { user: user }))
    end
  end

  permissions :delete_attachment? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:question,
                                                              { user: user }))
    end

    it 'grant access if user is author' do
      expect(subject).to permit(user, create(:question,
                                             { user: user }))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(User.new, create(:question,
                                                     { user: user }))
    end

    it 'denies access if user is not signed in' do
      expect(subject).not_to permit(nil, create(:question,
                                                { user: user }))
    end
  end

  permissions :like? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:question,
                                                              { user: user }))
    end

    it 'denies access if user is author of answer' do
      expect(subject).not_to permit(user, create(:question,
                                                 { user: user }))
    end

    it 'grant access if user is not author' do
      expect(subject).to permit(User.new, create(:question,
                                                 { user: user }))
    end

    it 'denies access if user is not signed in' do
      expect(subject).not_to permit(nil, create(:question,
                                                { user: user }))
    end
  end

  permissions :dislike? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:question,
                                                              { user: user }))
    end

    it 'denies access if user is author of answer' do
      expect(subject).not_to permit(user, create(:question,
                                                 { user: user }))
    end

    it 'grant access if user is not author' do
      expect(subject).to permit(User.new, create(:question,
                                                 { user: user }))
    end

    it 'denies access if user is not signed in' do
      expect(subject).not_to permit(nil, create(:question,
                                                { user: user }))
    end
  end

  permissions :unvote? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:question,
                                                              { user: user }))
    end

    it 'denies access if user is author of answer' do
      expect(subject).not_to permit(user, create(:question,
                                                 { user: user }))
    end

    it 'grant access if user is not author' do
      expect(subject).to permit(User.new, create(:question,
                                                 { user: user }))
    end

    it 'denies access if user is not signed in' do
      expect(subject).not_to permit(nil, create(:question,
                                                { user: user }))
    end
  end
end
