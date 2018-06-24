class Question < ApplicationRecord

  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def set_the_best_answer(answer)
    Question.transaction do
      answers.update_all(best: false)
      answer.update!(best: true)
    end
  end

  def vote_by_user(user)
    votes.vote_by_user(user).first
  end

  def vote_up(user)
    make_a_vote(1, user)
  end

  def vote_down(user)
    make_a_vote(-1, user)
  end

  def delete_vote(user)
    @vote = vote_by_user(user)
    @vote.destroy unless @vote.nil?
  end

  private
    def make_a_vote(value, user)
      @vote = votes.create(value: value, user: user)
    end
end
