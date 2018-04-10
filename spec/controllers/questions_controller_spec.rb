require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'pupulates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    before { get :show, params: { id: question } }

    it 'assigns object to @question variable' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question variable' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question' do
        expect { post :create, params: { question: attributes_for(:question)} }.to change(Question, :count).by(1)
      end
      it 'redirects to show' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question)} }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question) }
    let(:action) { delete :destroy, id: question }

    context 'if question belongs to the user' do

      it 'deletes question' do
        sign_in_as_user(question.user)
        expect { :action }.to change(Question, :count).by(-1)
      end

      it 'redirects to questions index' do
        sign_in_as_user(question.user)
        action
        expect(response).to redirect_to questions_path
      end
    end

    context 'if question does not belong to the user' do
      let(:user) { create(:user) }

      it 'does not delete question' do
        sign_in(user)
        expect { :action }.to_not change(Question, :count)
      end
    end

  end
end
