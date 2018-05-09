require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }

  it { should validate_presence_of :body }

  describe '#best?' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:another_answer) { create(:answer, question: question)}

    it '#best?' do
      question.best_answer = answer
      expect(answer.best?).to be_truthy
    end

    it 'rechoose best' do
      question.best_answer = answer
      question.best_answer = another_answer
      expect(another_answer.best?).to be_truthy
    end
  end
end
