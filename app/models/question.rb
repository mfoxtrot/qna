class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true

  def set_the_best_answer(value)
    self.answers.each do |answer|
      answer.best = (answer==value)
      answer.save
    end
  end
end
