require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before do
      get :index
    end

    it 'pupulates an array of all questions' do
      expect(assigns(:questions)).to_match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
