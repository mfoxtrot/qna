require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "POST #find" do
    let(:search_string) { 'Some string' }
    let(:find_action) { post :find, params: {search_field: search_string} }
    it 'returns http success' do
      find_action
      expect(response).to have_http_status(:success)
    end

    it 'runs search over questions' do
      %w(questions answers comments users).each do |class_name|
        expect(class_name.classify.constantize).to receive(:search).with(search_string)
      end
      find_action
    end
  end
end
