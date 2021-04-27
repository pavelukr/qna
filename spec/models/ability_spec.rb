require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for guest' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let!(:user) { create(:user) }
    let!(:other) { create(:user) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it {
      should be_able_to :update, create(:answer,
                                        question: create(:question, user: user), user: user), user: user
    }
    it {
      should_not be_able_to :update, create(:answer,
                                            question: create(:question, user: user), user: other), user: user
    }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it {
      comments = create_list(:comment, 2, { view: 1, user_id: user.id })
      should be_able_to :delete_comment,
                        create(:question, comments: comments, user: user)
    }
    it { should_not be_able_to :delete, create(:question, user: other), user: user }
    it {
      should_not be_able_to :delete, create(:answer,
                                            question: create(:question, user: user), user: other), user: user
    }
  end
end
