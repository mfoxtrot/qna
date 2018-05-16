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

    it 'sorts answers' do
      best_answer = question.answers[5]
      question.set_the_best_answer(best_answer)
      question.reload
      expect(question.answers[0]).to eq best_answer
    end

    it 'set_the_best_answer' do
      best_answer = question.answers[5]
      question.set_the_best_answer(best_answer)

      expect(best_answer.best?).to be_truthy
    end
  end
end
