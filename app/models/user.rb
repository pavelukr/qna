class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github, :twitter]

  has_many :answers
  has_many :questions
  has_many :votes
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions
  after_create :confirm_email

  def creator_of(object)
    true if object.user == self
  end

  def self.send_daily
    questions = Question.list_of_questions
    find_each.each do |user|
      UserMailer.new_questions_list(user, questions).deliver_later
    end
  end

  def confirm_email
    UserMailer.sign_in_confirm(self).deliver_now
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by provider: auth.provider, uid: auth.uid.to_s
    return authorization.user if authorization

    email = auth.info[:email]
    return if email.nil?

    user = User.where(email: email).first
    if user
      user.authorizations&.create(provider: auth.provider, uid: auth.uid)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations&.create(provider: auth.provider, uid: auth.uid)
    end
    user
  end

  def self.find_for_oauth_without_email(email, provider, uid)
    user = User.where(email: email).first
    if user
      user.authorizations&.create(provider: provider, uid: uid)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations&.create(provider: provider, uid: uid)
    end
    user
  end
end
