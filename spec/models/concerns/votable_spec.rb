require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:obj) { create(model.to_s.underscore.to_sym) }

  it '#vote_up' do
    obj.vote_up(user)
    expect(obj.votes.count).to eq(1)
  end

  it '#vote_down' do
    obj.vote_down(user)
    expect(obj.votes.count).to eq(1)
  end

  it '#delete_vote' do
    obj.vote_up(user)
    obj.delete_vote(user)
    expect(obj.votes.count).to be_zero
  end

  it '#vote_by_user' do
    vote = create(:vote, votable: obj, user: user)
    expect(obj.vote_by_user(user)).to eq vote
  end
end
