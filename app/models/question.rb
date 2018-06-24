class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def set_the_best_answer(answer)
    Question.transaction do
      answers.update_all(best: false)
      answer.update!(best: true)
    end
  end

end
