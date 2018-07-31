shared_examples_for 'Votable controller' do

  let(:vote_up_action) { post :vote_up, params: {id: votable}, format: :json }
  let(:vote_down_action) { post :vote_down, params: {id: votable}, format: :json }
  let(:vote_delete_action) { post :vote_delete, params: {id: votable_with_vote}, format: :json }

  context 'Non authenticated user' do
    it 'is not able to vote up' do
      expect { vote_up_action }.to_not change(Vote, :count)
    end
    it 'is not able to vote down' do
      expect { vote_down_action }.to_not change(Vote, :count)
    end
    it 'is not able to delete a vote' do
      expect { vote_delete_action }.to_not change(Vote, :count)
    end
  end

  context 'Author of the question' do
    it 'is not able to make a vote' do
      sign_in(votable.author)
      expect { vote_up_action }.to_not change(Vote, :count)
    end
    it 'is not able to vote down' do
      sign_in(votable.author)
      expect { vote_down_action }.to_not change(Vote, :count)
    end
    it 'is not able to delete a vote' do
      sign_in(votable_with_vote.author)
      expect { vote_delete_action }.to_not change(Vote, :count)
    end
  end

  context 'Non-author of the question' do
    it 'is able to vote up' do
      sign_in(user)
      expect { vote_up_action }.to change(Vote, :count).by(1)
    end

    it 'is able to vote down' do
      sign_in(user)
      expect { vote_down_action }.to change(Vote, :count).by(1)
    end

    it 'is able to delete his vote' do
      sign_in(user)
      expect { vote_delete_action }.to change(Vote, :count).by(-1)
    end
  end
end
