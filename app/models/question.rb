class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions, source: :user

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
    author.subscribed_questions << self
  end

end
