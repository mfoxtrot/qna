require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'guests' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all}
  end

  describe 'admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'user' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, author: user) }
    let!(:vote_for_question) { question.votes.create(user: user, value: 1) }
    let!(:vote_for_answer) { answer.votes.create(user: user, value: 1) }
    let(:another_question) { create(:question)}
    let!(:vote_for_another_question) { another_question.votes.create(user: another_user, value: 1)}
    let(:another_answer) { create(:answer)}
    let!(:vote_for_another_answer) { another_answer.votes.create(user: another_user, value: 1)}

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, author: user)}
    it { should_not be_able_to :update, create(:question, author: another_user)}
    it { should_not be_able_to :update, create(:answer, author: another_user)}

    it { should be_able_to :delete, create(:question, author: user)}
    it { should_not be_able_to :delete, create(:question, author: another_user)}
    it { should_not be_able_to :delete, create(:answer, author: another_user)}

    it { should be_able_to :set_as_the_best, create(:answer, question: question)}
    it { should_not be_able_to :set_as_the_best, create(:answer)}

    it { should be_able_to :vote_up, create(:question)}
    it { should be_able_to :vote_up, create(:answer)}
    it { should_not be_able_to :vote_up, question}
    it { should_not be_able_to :vote_up, answer}

    it { should be_able_to :vote_down, create(:question)}
    it { should be_able_to :vote_down, create(:answer)}
    it { should_not be_able_to :vote_down, question}
    it { should_not be_able_to :vote_down, answer}

    it { should be_able_to :delete_vote, question}
    it { should_not be_able_to :delete_vote, another_question}
    it { should be_able_to :delete_vote, answer}
    it { should_not be_able_to :delete_vote, another_answer}

  end
end
