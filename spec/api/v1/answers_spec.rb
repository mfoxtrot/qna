require 'features_helper'

describe 'Answers API' do
  describe 'GET /v1/questions/{id}/answers' do
    let(:question) { create(:question_with_answers) }

    context 'unauthorized' do

      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: {format: :json, access_token: '12345'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user)}
      let(:access_token) { create(:access_token, resource_owner_id: me.id)}

      before {get "/api/v1/questions/#{question.id}/answers", params: {format: :json, access_token: access_token.token}}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns all question answers' do
        expect(response.body).to have_json_size(question.answers.count).at_path("answers")
      end

      %w(id body question_id created_at updated_at author_id best rating).each do |attr|
        it "question object has #{attr}" do
          answer = question.answers.first
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end


end
