require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }

  it { should validate_presence_of :body }

  describe '#best?' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    it '#best?' do
      question.best_answer = answer
      expect(answer.best?).to be_true
    end
  end
end
