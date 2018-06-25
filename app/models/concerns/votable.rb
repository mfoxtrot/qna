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
    @vote.destroy unless @vote.nil?
  end

  def vote_up_path
    get_route "vote_up_#{resource_name}_path"
  end

  def vote_down_path
    get_route "vote_down_#{resource_name}_path"
  end

  def vote_delete_path
    get_route "vote_delete_#{resource_name}_path"
  end

  private
    def make_a_vote(value, user)
      @vote = votes.create(value: value, user: user)
    end

    def resource_name
      model_name.param_key
    end

    def get_route(method_name)
      send(method_name.to_sym, self)
    end
end
