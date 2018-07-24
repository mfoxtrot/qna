require 'features_helper'

describe 'Answers API' do
  let(:question) { create(:question_with_answers) }
  let!(:answer) { question.answers.first }
  let(:me) { create(:user)}
  let(:access_token) { create(:access_token, resource_owner_id: me.id)}

  describe 'GET /v1/questions/{id}/answers' do
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

      context 'api/v1/questions/{id}/asnwers' do

        before {get "/api/v1/questions/#{question.id}/answers", params: {format: :json, access_token: access_token.token}}

        it 'returns 200 status' do
          expect(response).to be_success
        end

        it 'returns all question answers' do
          expect(response.body).to have_json_size(question.answers.count).at_path('answers')
        end

        %w(id body question_id created_at updated_at author_id best rating).each do |attr|
          it "question object has #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /v1/answers/{id}' do

    context 'Unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: {format: :json, access_token: '12345'}
        expect(response.status).to eq 401
      end
    end

    context 'Authorized' do
      before {get "/api/v1/answers/#{answer.id}", params: {format: :json, access_token: access_token.token}}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body question_id created_at updated_at author_id best rating).each do |attr|
        it "question object has #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do

        let!(:comment) { create(:answer_comment, commentable: answer)}
        before {get "/api/v1/answers/#{answer.id}", params: {format: :json, access_token: access_token.token}}

        it 'has a list of comments' do
          expect(response.body).to have_json_size(answer.comments.count).at_path('answer/comments')
        end

        %w(id body user_id created_at updated_at).each do |attr|
          it "comment object has #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        let!(:attachment) { create(:attachment, attachable: answer)}
        before {get "/api/v1/answers/#{answer.id}", params: {format: :json, access_token: access_token.token}}

        it 'attachment object has link attribute' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('answer/attachments/0/link')
        end
      end
    end
  end
end
