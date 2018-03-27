require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #new' do
    let(:question) { create(:question) }

    before { get :new, params: { question_id: question.id } }

    it 'assigns a new Answer to @answer variable' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'should be a nested resource to question' do
      expect(assigns(:answer).question).to eq question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }
    context 'with valid attributes' do
      it 'saves the new answer' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id} }.to change(Answer, :count).by(1)
      end
      it 'redirects to question#show' do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id }
        expect(response).to redirect_to question_path(assigns(:answer).question)
      end
    end
  end
end
