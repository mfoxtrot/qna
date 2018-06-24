require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let!(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'pupulates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let!(:question) { create(:question) }
    let!(:question_with_answers) { create(:question_with_answers) }
    before { get :show, params: { id: question } }

    it 'assigns object to @question variable' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new @answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'builds new attachment for the answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
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

    it 'builds new attachment for the question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      let(:post_valid_params) { post :create, params: { question: attributes_for(:question)} }

      it 'saves the new question' do
        expect { post_valid_params }.to change(Question, :count).by(1)
      end

      it 'redirects to show' do
        post_valid_params
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'adds new question to current_user''s collection' do
        expect { post_valid_params }.to change(@user.questions, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      let(:post_invalid_params) { post :create, params: { question: attributes_for(:invalid_question)}  }

      it 'does not save the question' do
        expect { post_invalid_params }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post_invalid_params
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let(:delete_action) { delete :destroy, params: {id: question} }

    context 'if question belongs to the user' do
      it 'deletes question' do
        question
        sign_in(question.author)
        expect { delete_action }.to change(Question, :count).by(-1)
      end

      it 'redirects to questions index' do
        sign_in(question.author)
        delete_action
        expect(response).to redirect_to questions_path
      end
    end

    context 'if question does not belong to the user' do
      let(:user) { create(:user) }


      it 'does not delete question' do
        question
        sign_in(user)
        expect { delete_action }.to_not change(Question, :count)
      end

      it 'redirects to question#show' do
        question
        sign_in(user)
        delete_action
        expect(response).to redirect_to question_path(question)
      end
    end

  end

  describe 'PATCH #update' do
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }
    let!(:users_question) { create(:question, author: user) }

    context 'Non-authenticated user' do
      it 'is not able to change question' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js }
        question.reload
        expect(question.title).not_to eq 'new title'
        expect(question.body).not_to eq 'new body'
      end
    end

    context 'Authenticated user' do
      it 'non-author cant change question' do
        sign_in(user)
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js }
        question.reload
        expect(question.title).not_to eq 'new title'
        expect(question.body).not_to eq 'new body'
      end

      it 'author can change his question' do
        sign_in(user)
        patch :update, params: { id: users_question, question: { title: 'new title', body: 'new body'}, format: :js }
        users_question.reload
        expect(users_question.title).to eq 'new title'
        expect(users_question.body).to eq 'new body'
      end
    end
  end

  describe 'User can make a vote' do
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }
    let!(:question_with_vote) { create(:question) }
    let!(:vote) { create(:vote, user: user, votable: question_with_vote, value: 1)}
    let(:vote_up_action) { post :vote_up, params: {id: question}, format: :json }
    let(:vote_down_action) { post :vote_down, params: {id: question}, format: :json }
    let(:vote_delete_action) { post :vote_delete, params: {id: question_with_vote}, format: :json}

    context 'Non authenticated user' do
      it 'is not able to vote up' do
        expect { vote_up_action }.to_not change(Vote, :count)
      end
      it 'is not able to vote down' do
        expect { vote_up_action }.to_not change(Vote, :count)
      end
      it 'is not able to delete a vote' do
        expect { vote_delete_action }.to_not change(Vote, :count)
      end
    end

    context 'Author of the question' do
      it 'is not able to make a vote' do
        sign_in(question.author)
        expect { vote_up_action }.to_not change(Vote, :count)
      end
      it 'is not able to vote down' do
        sign_in(question.author)
        expect { vote_up_action }.to_not change(Vote, :count)
      end
      it 'is not able to delete a vote' do
        sign_in(question_with_vote.author)
        expect { vote_delete_action }.to_not change(Vote, :count)
      end
    end

    context 'Non-author of the question' do
      it 'is able to vote up' do
        sign_in(user)
        expect { vote_up_action }.to change(Vote, :count).by(1)
      end

      it 'is able to vote down' do
        sign_in(user)
        expect { vote_down_action }.to change(Vote, :count).by(1)
      end

      it 'is able to delete his vote' do
        sign_in(user)
        expect { vote_delete_action }.to change(Vote, :count).by(-1)
      end
    end
  end
end
