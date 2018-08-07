class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'
  has_many :attachments, as: :attachable, dependent: :destroy
  has_and_belongs_to_many :subscribers, class_name: "User"

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  after_create :add_subscription_for_author

  def set_the_best_answer(answer)
    Question.transaction do
      answers.update_all(best: false)
      answer.update!(best: true)
    end
  end

  private

  def add_subscription_for_author
    author.subscriptions << self
  end

end
