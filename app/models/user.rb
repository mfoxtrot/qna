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

  accepts_nested_attributes_for :authorizations

  def author_of?(obj)
    obj.author_id == self.id
  end

  def self.find_for_oauth(auth)
    provider, uid = auth.provider, auth.uid.to_s
    authorization = Authorization.where(provider: provider, uid: uid.to_s).first
    return authorization.user if authorization
    return User.new unless auth.info.has_key?(:email)
    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.create_authorization(provider, uid)
      return user
    else
      password = Devise.friendly_token[0,20]
      user = User.create!(email: email, password: password, password_confirmation: password, confirmed_at: Time.now)
      user.create_authorization(provider, uid)
      return user
    end
  end

  def create_authorization(provider, uid)
    self.authorizations.create(provider: provider, uid: uid)
  end

end
