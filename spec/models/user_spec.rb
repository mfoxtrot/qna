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

  describe 'author_of? method' do
    let!(:user) { create(:user) }

    describe 'for questions' do
      let(:users_question) { create(:question, author: user) }
      let(:question) { create(:question) }
      it 'should be the author_of? for created questions' do
        expect(user.author_of?(users_question)).to be true
      end
      it 'should not be the author_of? for created questions' do
        expect(user.author_of?(question)).not_to be true
      end
    end

    describe 'for answers' do
      let!(:users_answer) { create(:answer, author: user) }
      let!(:answer) { create(:answer) }

      it 'should be the author_of? for created answers' do
        expect(user.author_of?(users_answer)).to be true
      end
      it 'should not be the author_of? for created answers' do
        expect(user.author_of?(answer)).not_to be true
      end
    end
  end
end
