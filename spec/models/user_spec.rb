require 'rails_helper'

RSpec.describe User do
  describe 'Associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_and_belong_to_many(:subscriptions) }
  end

  describe 'Validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe '#author_of?' do
    let!(:user) { create(:user) }
    let(:users_question) { create(:question, author_id: user.id) }

    it '#author_of?' do
      expect(user).to be_author_of(users_question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let!(:auth) { OmniAuth::AuthHash.new(provider: 'provider', uid: '0123456789')}

    context 'User has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'provider', uid: '0123456789')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'User has no authorization' do
      context 'User exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'provider', uid: '0123456789', info: {email: user.email}) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end
        it 'creates new authoriztion for the user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end
        it 'creates new authoriztion with correct provider and uid' do
          user = User.find_for_oauth(auth)
          authoriztion = user.authorizations.first
          expect(authoriztion.provider).to eq auth.provider
          expect(authoriztion.uid).to eq auth.uid
        end
        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let!(:auth) { OmniAuth::AuthHash.new(provider: 'provider', uid: '0123456789', info: {email: 'johndoe@test.com'})}
        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
        it 'has correct user email' do
          expect(User.find_for_oauth(auth).email).to eq auth.info[:email]
        end
        it 'creates authorization for the user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).not_to be_empty
        end

        it 'create authorization with correct provider and uid' do
          user = User.find_for_oauth(auth)
          authoriztion = user.authorizations.first
          expect(authoriztion.provider).to eq auth.provider
          expect(authoriztion.uid).to eq auth.uid
        end
      end
    end
  end
end
