require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :request do
  describe 'POST /auth/login' do
    # create test user
    let!(:user) { create(:user) }
    # set headers for authorization
    let(:api_v_headers) { api_valid_headers_without_authorization }
    # set test valid and invalid credentials
    let(:user_v_email_credentials) { user_valid_email_credentials }
    let(:user_v_username_credentials) { user_valid_username_credentials }
    let(:user_inv_credentials) { user_invalid_credentials }

    # returns auth token when request is valid
    context 'When request is valid with email' do
      before do
        post api_auth_login_path, params: user_v_email_credentials.to_json, headers: api_v_headers
      end

      it 'returns non-empty authentication token' do
        expect(json['data']['auth_token']).not_to be_nil
      end

      it 'returns successfully authenticated message' do
        expect(json['message']).to eq Message.user_successfully_authenticated
      end

      it_behaves_like 'returns 200 success status'
    end

    context 'When request is valid with username' do
      before do
        post api_auth_login_path, params: user_v_username_credentials.to_json, headers: api_v_headers
      end

      it 'returns non-empty authentication token' do
        expect(json['data']['auth_token']).not_to be_nil
      end

      it 'returns successfully authenticated message' do
        expect(json['message']).to eq Message.user_successfully_authenticated
      end

      it_behaves_like 'returns 200 success status'
    end

    # returns failure message when request is invalid
    context 'When request is invalid' do
      context "with invalid credentials" do
        before do
          post api_auth_login_path, params: user_inv_credentials.to_json, headers: api_v_headers
        end

        it 'returns a failure message' do
          expect(json['errors']['message']).to eq Message.invalid_credentials
        end

        it_behaves_like 'returns 401 unauthorized status'
      end

      context "with invalid authenticity token" do
        it_behaves_like 'when csrf token is not present', '/auth/login'
      end
    end
  end
end
