require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end
  end

  context 'authorized me' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

    it 'returns 200 status' do
      expect(response.status).to eq 200
    end

    %w[id email created_at updated_at admin].each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
      end
    end

    %w[password encrypted_password].each do |attr|
      it "does not contain #{attr}" do
        expect(response.body).to_not have_json_path(attr)
      end
    end
  end

  describe 'GET #index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end
  end

  context 'authorized index' do
    let(:me) { create(:user) }
    let!(:users) { create_list(:user, 3) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }

    it 'returns 200 status' do
      expect(response.status).to eq 200
    end

    %w[id email created_at updated_at admin].each do |attr|
      it "doesn't contains my #{attr}" do
        expect(response.body).to_not be_json_eql(me.send(attr.to_sym).to_json)
      end
    end

    %w[password encrypted_password].each do |attr|
      it "does not contain #{attr}" do
        expect(response.body).to_not have_json_path(attr)
      end
    end
  end
end
