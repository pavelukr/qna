# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user
    can :like, [Question, Answer] do |votable|
      votable.user != user
    end

    can :dislike, [Question, Answer] do |votable|
      votable.user != user

    end

    can :unvote, [Question, Answer] do |votable|
      votable.user != user
    end

    can :select_best, Answer, question: { user: user }

    can :delete_attachment, [Question, Answer], question: { user: user }

=begin
    can :delete_comment, [Question, Answer] do |commentable|
      commentable.user != user
    end
=end

    can :delete_comment, Answer do |commentable|
      commentable.user == user
    end

    can :delete_comment, Question do |commentable|
      commentable.user == user
    end
    #can :read, Step, steppable_type: 'OtherThing', steppable_id: OtherThing.published.pluck(:id)

    can :create_comment, [Question, Answer]
  end
end
