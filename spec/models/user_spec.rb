require 'rails_helper'

RSpec.describe User do
  describe 'Associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
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
end
