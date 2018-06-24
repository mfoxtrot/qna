module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
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
