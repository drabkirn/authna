require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let(:user) { build(:user) }
  let(:api_v_headers) { api_valid_headers_without_authorization }
  let(:user_valid_email_credentials) do
    attributes_for(:user, password_confirmation: user.password)
  end

  let(:user_invalid_credentials) do
    {
      user: {
        email: ""
      }
    }.to_json
  end

  # User signup test suite
  describe 'POST /auth/signup' do
    context 'when valid request' do
      before do
        post api_auth_signup_path, params: { user: user_valid_email_credentials }.to_json, headers: api_v_headers
      end

      it 'returns success message' do
        expect(json['data']['message']).to eq Message.user_account_created
      end

      it 'returns an authentication token' do
        expect(json['data']['auth_token']).not_to be_nil
      end

      it 'returns user data' do
        auth_user_obj = {
          email: json['data']['user_email'],
          username: json['data']['user_username'],
          user_otp_secret_key: json['data']['user_otp_secret_key'],
          user_otp_module: json['data']['user_otp_module'],
          user_email_confirmation: json['data']['user_email_confirmation'],
          user_github_linked: json['data']['user_github_linked']
        }
        user.otp_secret_key = json['data']['user_otp_secret_key']
        user_obj = {
          email: user_valid_email_credentials[:email],
          username: user_valid_email_credentials[:username],
          user_otp_secret_key: user.otp_secret_key,
          user_otp_module: user.otp_module,
          user_email_confirmation: user_valid_email_credentials[:confirmed_at],
          user_github_linked: user.provider?
        }
        expect(auth_user_obj).to eq user_obj
      end

      it_behaves_like 'returns 201 created status'
    end

    context 'when invalid request' do
      context "when invalid credentials" do
        before do
          post api_auth_signup_path, params: user_invalid_credentials, headers: api_v_headers
        end
        
        it 'returns failure message' do
          expect(json['errors']['message'])
            .to match(/Validation failed: Email can't be blank, Password can't be blank, Username can't be blank/)
        end

        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "with invalid authenticity token" do
        it_behaves_like 'when csrf token is not present', '/auth/signup'
      end
    end
  end
end