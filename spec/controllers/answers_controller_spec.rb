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
end
