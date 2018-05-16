class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def best?
    self.best
  end
end
