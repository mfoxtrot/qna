require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    sign_in_user
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
    sign_in_user
    context 'with valid attributes' do
      let(:action) { post :create, params: { question_id: question.id, answer: attributes_for(:answer)} }

      it 'saves the new answer' do
        expect { action }.to change(question.answers, :count).by(1)
      end
      it 'redirects to question#show' do
        action
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      let(:action) { post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer)} }

      it 'does not save the new answer' do
        expect { action }.to_not change(Answer, :count)
      end
      it 're-renders new view' do
        action
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:answer) { create(:answer) }

    context 'if answer belongs to the user' do

      it 'deletes answer' do
        answer
        sign_in(answer.author)
        expect { delete :destroy, params: {id: answer} }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show' do
        sign_in(answer.author)
        delete :destroy, params: {id: answer}
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'if answer does not belong to the user' do
      let(:user) { create(:user) }

      it 'does not delete answer' do
        answer
        sign_in(user)
        expect { delete :destroy, params: {id: answer} }.to_not change(Answer, :count)
      end
    end

  end
end
