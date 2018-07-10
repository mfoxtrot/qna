class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable, omniauth_providers: [:github, :meetup]

  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :votes
  has_many :comments
  has_many :authorizations

  def author_of?(obj)
    obj.author_id == self.id
  end

  def self.find_for_oauth(auth)
    find_user_by_authorization(auth) || find_user_by_email(auth) || create_user_if_not_exists(auth)
  end

  def self.find_user_by_authorization(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
  end

  def self.find_user_by_email(auth)
    if auth.info.has_key?(:email)
      user = User.where(email: auth.info[:email]).first
      if user
        user.create_authorization(auth)
        user
      end
    end
  end

  def self.create_user_if_not_exists(auth)
    if auth.info.has_key?(:email)
      provider, uid, email = auth.provider, auth.uid.to_s, auth.info[:email]
      password = Devise.friendly_token[0,20]
      user = User.create!(email: email, password: password, password_confirmation: password, confirmed_at: Time.now)
      user.create_authorization(auth)
      user
    end
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
  end
end
