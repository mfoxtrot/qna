require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'Associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:author) }
  end

  describe 'Validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe 'Methods' do
    let!(:question) { create(:question_with_answers) }

    it 'sorted_answers' do
      best_answer = question.answers[5]
      question.best_answer = best_answer

      expect(question.sorted_answers[0]).to eq best_answer
    end
  end
end
