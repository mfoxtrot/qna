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

    can :create, [Question, Answer]

    can :update, Question, author_id: user.id
    can :update, Answer, author_id: user.id

    can :destroy, Question, author_id: user.id
    can :destroy, Answer, author_id: user.id

    can :create_comment, [Question, Answer]

    can :set_as_the_best, Answer, question: { author_id: user.id }

    can [:vote_up, :vote_down], [Question, Answer] { |votable| votable.author_id != user.id }

    can :vote_delete, [Question, Answer] { |votable| votable.votes.exists?(user_id: user.id) }

    can [:me, :list], User

    can :subscribe, Question
    cannot :subscribe, Question, id: user.subscriptions.pluck(:id)
    can :unsubscribe, Question, id: user.subscriptions.pluck(:id)
  end
end
