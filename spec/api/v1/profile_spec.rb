require 'features_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do

      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: {format: :json, access_token: '12345'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user)}
      let(:access_token) { create(:access_token, resource_owner_id: me.id)}

      before {get '/api/v1/profiles/me', params: {format: :json, access_token: access_token.token}}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "doesnt contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /list' do
    context 'unauthorized' do

      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/list', params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/list', params: {format: :json, access_token: '12345'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user)}
      let(:access_token) { create(:access_token, resource_owner_id: me.id)}

      before { 20.times { create(:user)} }
      before {get '/api/v1/profiles/list', params: {format: :json, access_token: access_token.token}}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'contains N-1 records' do
        expect(response.body).to have_json_size(User.all.count-1)
      end

      it 'does not contain current_user profile' do
        expect(response.body).to_not include_json(me.to_json)
      end


      %w(id email created_at updated_at admin).each do |attr|
        it "each profile contains #{attr}" do
          JSON.parse(response.body).each do |user|
            expect(user).to have_key(attr)
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "each profile doesnt contain #{attr}" do
          JSON.parse(response.body).each do |user|
            expect(user).not_to have_key(attr)
          end
        end
      end
    end
  end
end
