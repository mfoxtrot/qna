require 'features_helper'

describe 'Question API' do
  describe 'GET /v1/questions' do

    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authenticable'

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

    let(:api_path) { '/api/v1/questions/1' }
    it_behaves_like 'API Authenticable'

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

  describe 'POST /v1/questions' do
    let(:question_params) { attributes_for(:question) }

    let(:method_name) { :post }
    let(:api_path) { '/api/v1/questions' }
    let(:request_params) { {question: question_params} }
    it_behaves_like 'API Authenticable'

    context 'Authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id)}
      let(:post_valid_params) { post '/api/v1/questions', params: { format: :json, access_token: access_token.token, question: question_params }}
      let(:post_invalid_params) { post '/api/v1/questions', params: { format: :json, access_token: access_token.token, question: question_params.except!(:body) }}

      context 'with valid params' do
        it 'creates question if passing valid params' do
          expect { post_valid_params }.to change(Question, :count).by(1)
        end
      end

      context 'with invalid params' do
        it "doesn't create a question" do
          expect { post_invalid_params }.not_to change(Question, :count)
        end
      end
    end
  end

  def do_request(options = {})
    method_name ||= :get
    request_params ||= {}
    send method_name, api_path, params: {format: :json}.merge(options).merge(request_params)
  end
end
