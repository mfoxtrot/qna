module Votable
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

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
    unless @vote.nil?
      @vote.destroy
      self.update!(rating: votes.sum(:value))
    end
  end

  private
    def make_a_vote(value, user)
      @vote = votes.create(value: value, user: user)
      self.update!(rating: votes.sum(:value))
      @vote
    end

    def resource_name
      model_name.param_key
    end

    def get_route(method_name)
      send(method_name.to_sym, self)
    end
end
