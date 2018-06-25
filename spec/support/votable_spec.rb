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

  it '#vote_up_path' do
    expect(obj.vote_up_path).to eq("/#{obj.class.to_s.underscore.pluralize}/#{obj.id}/vote_up")
  end

  it '#vote_down_path' do
    expect(obj.vote_down_path).to eq("/#{obj.class.to_s.underscore.pluralize}/#{obj.id}/vote_down")
  end

  it '#vote_delete_path' do
    expect(obj.vote_delete_path).to eq("/#{obj.class.to_s.underscore.pluralize}/#{obj.id}/vote_delete")
  end

  it 'increases rating on vote_up' do
    obj.vote_up(user)
    expect(obj.rating).to eq(1)
  end

  it 'decreases rating on vote_down' do
    obj.vote_down(user)
    expect(obj.rating).to eq(-1)
  end

  it 'decreases rating on delete_vote' do
    obj.vote_up(user)
    obj.delete_vote(user)
    expect(obj.rating).to be_zero
  end
end
