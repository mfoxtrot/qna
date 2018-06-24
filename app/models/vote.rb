class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, optional: true
  belongs_to :user

  validates :user, presence: true
  validates :value, presence: true

  scope :vote_by_user, -> (user){ where(user: user) }

end
