class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, optional: true, touch: true
  belongs_to :user

  validates :user, presence: true
  validates :body, presence: true

end
