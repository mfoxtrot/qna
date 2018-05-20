require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'Associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:author) }
    it { should have_many(:attachments).dependent(:destroy) }
  end

  describe 'Validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it { should accept_nested_attributes_for :attachments }

  describe '#set_the_best_answer' do
    let!(:question) { create(:question_with_answers) }

    it 'sets the best answer' do
      best_answer = question.answers[5]
      question.set_the_best_answer(best_answer)
      best_answer.reload
      expect(best_answer).to be_best
    end

    it 'resets the best answer' do
      best_answer = question.answers[5]
      question.set_the_best_answer(best_answer)
      new_best_answer = question.answers[7]
      question.set_the_best_answer(new_best_answer)
      new_best_answer.reload
      expect(new_best_answer).to be_best
    end
  end

  describe 'answers sorted by the best attribute' do
    let!(:question) { create(:question_with_answers) }
    it 'sorts answers' do
      best_answer = question.answers[5]
      question.set_the_best_answer(best_answer)
      question.reload
      expect(question.answers[0]).to eq best_answer
    end
  end
end
