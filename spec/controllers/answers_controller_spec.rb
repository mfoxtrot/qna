require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      let(:action) { post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js} }

      it 'saves the new answer' do
        expect { action }.to change(question.answers, :count).by(1)
      end
      it 'render answers/create' do
        action
        expect(response).to render_template 'answers/create'
      end
      it 'adds new answer to current_user''s collection' do
        expect { action }.to change(@user.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      let(:action) { post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer), format: :js} }

      it 'does not save the new answer' do
        expect { action }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }
    let(:delete_action) { delete :destroy, params: {id: answer} }

    context 'if answer belongs to the user' do

      it 'deletes answer' do
        answer
        sign_in(answer.author)
        expect { delete_action }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show' do
        sign_in(answer.author)
        delete_action
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'if answer does not belong to the user' do
      let!(:user) { create(:user) }

      it 'does not delete answer' do
        answer
        sign_in(user)
        expect { delete_action }.to_not change(Answer, :count)
      end

      it 'redirects to question#show' do
        answer
        sign_in(user)
        delete_action
        expect(response).to redirect_to question_path(answer.question)
      end
    end

  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question) }
    let(:update) { patch :update, params: { id: answer, question_id: question.id, answer: attributes_for(:answer), format: :js} }
    let(:another_user) { create :user }

    context 'if answer belongs to the user' do

      it 'assigns the requested answer to @answer' do
        sign_in(answer.author)
        update
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the requested answers question to @question' do
        sign_in(answer.author)
        update
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        sign_in(answer.author)
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body'} }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update template' do
        sign_in(answer.author)
        update
        expect(response).to render_template :update
      end
    end

    context 'if answer does not belong to the user' do
      it 'does not change answer attributes' do
        sign_in(another_user)
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body'} }, format: :js
        answer.reload
        expect(answer.body).not_to eq 'new body'
      end
    end

  end
end
