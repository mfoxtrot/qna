class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true

  def set_the_best_answer(answer)
    Question.transaction do
      answers.update_all(best: false)
      answer.update!(best: true)
    end
  end
end
