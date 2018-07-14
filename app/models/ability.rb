class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? manage_all : user_abilities
    else
      read_all
    end
  end

  private

  def read_all
    can :read, :all
  end

  def manage_all
    can :manage, :all
  end

  def user_abilities
    read_all

    can :create, [Question, Answer, Comment]

    can :update, Question, author: user
    can :update, Answer, author: user

    can :delete, Question, author: user
    can :delete, Answer, author: user

    can :set_as_the_best, Answer, question: { author_id: user.id }

    can [:vote_up, :vote_down], [Question, Answer] { |votable| votable.author_id != user.id }

    can :delete_vote, [Question, Answer] { |votable| votable.votes.exists?(user: user) }
  end
end
