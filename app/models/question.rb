class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true

  def set_the_best_answer(value)
    Question.transaction do
      self.answers.update_all best: false
      self.answers.update(value.id, best: true)
    end
  end
end
