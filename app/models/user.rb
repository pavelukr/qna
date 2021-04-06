class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github, :gitlab, :twitter]

  has_many :answers
  has_many :questions
  has_many :votes
  has_many :authorizations, dependent: :destroy

  def creator_of(object)
    true if object.user == self
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    binding.pry
    email = auth.info[:email]
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

  def self.find_for_oauth_twitter(email, provider, uid)
    @user = User.where(email: email).first
    if @user
      @user.authorizations&.create(provider: provider, uid: uid)
    else
      password = Devise.friendly_token[0, 20]
      @user = User.create!(email: email, password: password, password_confirmation: password)
      @user.authorizations&.create(provider: provider, uid: uid)
    end
  end
end
