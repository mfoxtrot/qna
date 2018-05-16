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
    let(:delete_action) { delete :destroy, params: {id: answer}, format: :js }

    context 'if answer belongs to the user' do

      it 'deletes answer' do
        answer
        sign_in(answer.author)
        expect { delete_action }.to change(Answer, :count).by(-1)
      end
    end

    context 'if answer does not belong to the user' do
      let!(:user) { create(:user) }

      it 'does not delete answer' do
        answer
        sign_in(user)
        expect { delete_action }.to_not change(Answer, :count)
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

  describe 'PATCH #set_as_the_best' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:user) { create(:user) }
    let(:set_as_the_best) { patch :set_as_the_best, params: { id: answer.id }, format: :js }

    context 'Questions author' do
      before do
        sign_in(question.author)
      end

      it 'can choose the best answer' do
        set_as_the_best
        question.reload
        answer.reload
        expect(answer.best?).to be_truthy
      end
      it 'can choose only one answer as the best one' do
        another_answer = create(:answer, question: question)
        set_as_the_best
        question.reload
        another_answer.reload
        expect(another_answer.best?).to eq false
      end

      it 'can rechoose the best answer' do
        another_answer = create(:answer, question: question)
        set_as_the_best
        question.reload
        answer.reload
        patch :set_as_the_best, params: { id: another_answer.id }, format: :js
        question.reload
        another_answer.reload
        expect(another_answer.best?).to eq true
      end
    end

    context 'Non author' do
      it 'can not choose the best answer' do
        sign_in(user)
        set_as_the_best
        question.reload
        expect(answer.best?).to eq false
      end
    end
  end
end
