require 'features_helper'

describe 'Question API' do
  describe 'GET /v1/questions' do
    context 'unauthorized' do

      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: {format: :json}
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
      let(:questions) { create_list(:question, 10) }
      let!(:question) { questions.first }

      before {get '/api/v1/questions', params: {format: :json, access_token: access_token.token}}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns all questions' do
        expect(response.body).to have_json_size(Question.count).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object has #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        let!(:answer) { create(:answer, question: question)}
        before {get '/api/v1/questions', params: {format: :json, access_token: access_token.token}}
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object has #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end

    end
  end

  describe 'GET /v1/questions/{id}' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions/1', params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions/1', params: {format: :json, access_token: '12345'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user)}
      let(:access_token) { create(:access_token, resource_owner_id: me.id)}
      let(:question) { create(:question) }

      before {get "/api/v1/questions/#{question.id}", params: {format: :json, access_token: access_token.token}}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object has #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        let!(:comment) { create(:question_comment, commentable: question)}
        before {get "/api/v1/questions/#{question.id}", params: {format: :json, access_token: access_token.token}}
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body user_id created_at updated_at).each do |attr|
          it "comment object has #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        let!(:attachment) { create(:attachment, attachable: question)}
        before {get "/api/v1/questions/#{question.id}", params: {format: :json, access_token: access_token.token}}

        it 'attachment object has link attribute' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('question/attachments/0/link')
        end
      end
    end
  end
end
