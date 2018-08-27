# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profile API' do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: 'invalid_token_123' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      %w[id email].each do |attribute|
        it "contains #{attribute}" do
          expect(response.body).to be_json_eql(me.send(attribute.to_sym).to_json).at_path(attribute)
        end
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
        get '/api/v1/profiles', params: { format: :json, access_token: 'invalid_token_123' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:other_user) { create(:user) }
      let!(:other_one_user) { create(:user) }

      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return json with proper size' do
        expect(response.body).to have_json_size(2)
      end

      it 'returns json with proper data' do
        expect(response.body).to include_json(other_user.to_json)
        expect(response.body).to include_json(other_one_user.to_json)
      end
    end
  end
end
