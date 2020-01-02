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

      it 'returns an authentication token' do
        expect(json['data']['auth_token']).not_to be_nil
      end

      it 'returns successfully authenticated message' do
        expect(json['data']['message']).to eq Message.user_successfully_authenticated
      end

      it 'returns user data' do
        auth_user_obj = {
          id: json['data']['user_id'],
          email: json['data']['user_email'],
          username: json['data']['user_username'],
          user_otp_secret_key: json['data']['user_otp_secret_key'],
          user_otp_module: json['data']['user_otp_module'],
          user_email_confirmation: json['data']['user_email_confirmation']
        }
        user_obj = {
          id: user.id,
          email: user.email,
          username: user.username,
          user_otp_secret_key: user.otp_secret_key,
          user_otp_module: user.otp_module,
          user_email_confirmation: user.confirmed_at
        }
        expect(auth_user_obj).to eq user_obj
      end

      it_behaves_like 'returns 200 success status'
    end

    context 'When request is valid with username' do
      before do
        post api_auth_login_path, params: user_v_username_credentials.to_json, headers: api_v_headers
      end

      it 'returns an authentication token' do
        expect(json['data']['auth_token']).not_to be_nil
      end

      it 'returns successfully authenticated message' do
        expect(json['data']['message']).to eq Message.user_successfully_authenticated
      end

      it 'returns user data' do
        auth_user_obj = {
          id: json['data']['user_id'],
          email: json['data']['user_email'],
          username: json['data']['user_username'],
          user_otp_secret_key: json['data']['user_otp_secret_key'],
          user_otp_module: json['data']['user_otp_module'],
          user_email_confirmation: json['data']['user_email_confirmation'],
          user_github_linked: json['data']['user_github_linked']
        }
        user_obj = {
          id: user.id,
          email: user.email,
          username: user.username,
          user_otp_secret_key: user.otp_secret_key,
          user_otp_module: user.otp_module,
          user_email_confirmation: user.confirmed_at,
          user_github_linked: user.provider?
        }
        expect(auth_user_obj).to eq user_obj
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
