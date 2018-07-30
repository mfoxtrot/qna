require 'features_helper'

describe 'Profile API' do
  describe 'GET /me' do

    let(:api_path) { '/api/v1/profiles/me' }
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create(:user)}
      let(:access_token) { create(:access_token, resource_owner_id: me.id)}

      before {get '/api/v1/profiles/me', params: {format: :json, access_token: access_token.token}}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path("profile/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "doesnt contain #{attr}" do
          expect(response.body).to_not have_json_path("profile/#{attr}")
        end
      end
    end
  end

  describe 'GET /list' do

    let(:api_path) { '/api/v1/profiles/list'}
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create(:user)}
      let(:access_token) { create(:access_token, resource_owner_id: me.id)}

      before { 20.times { create(:user)} }
      before {get '/api/v1/profiles/list', params: {format: :json, access_token: access_token.token}}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'contains N-1 records' do
        expect(response.body).to have_json_size(User.all.count-1).at_path('profiles')
      end

      it 'does not contain current_user profile' do
        expect(response.body).to_not include_json(me.to_json).at_path('profiles')
      end


      %w(id email created_at updated_at admin).each do |attr|
        it "profile contains #{attr}" do
          JSON.parse(response.body)["profiles"].each do |user|
            expect(user).to have_key(attr)
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "each profile doesnt contain #{attr}" do
          JSON.parse(response.body)["profiles"].each do |user|
            expect(user).not_to have_key(attr)
          end
        end
      end
    end
  end

  def do_request(options = {})
    get api_path, params: {format: :json}.merge(options)
  end
end
