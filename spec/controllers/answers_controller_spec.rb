require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #new' do
    let(:question) { create(:question) }

    before { get :new, params: { question_id: question.id } }

    it 'assigns a new Question to @question variable' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'should be a nested resource to question' do
      expect(assigns(:answer).question).to eq question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end
end
