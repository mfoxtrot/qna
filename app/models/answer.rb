class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true

  default_scope { order(best: :desc) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

end
