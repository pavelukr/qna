require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  subject { described_class }

  permissions :create_comment? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:comment))
    end

    it 'grant access if user is signed in' do
      expect(subject).to permit(User.new(admin: false), create(:comment))
    end

    it 'denies access if user is not signed in' do
      expect(subject).not_to permit(nil, create(:comment))
    end
  end

  permissions :delete_comment? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:comment))
    end

    it 'grant access if user is author of comment' do
      user = create(:user)
      expect(subject).to permit(user, create(:comment, { user_id: user.id }))
    end

    it 'denies access if user is not author of comment' do
      expect(subject).to permit(User.new(admin: false), create(:comment))
    end

    it 'denies access if user is not signed in' do
      expect(subject).not_to permit(nil, create(:comment))
    end
  end
end
