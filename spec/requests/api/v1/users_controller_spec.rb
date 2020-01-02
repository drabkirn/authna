require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let(:user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end

  let(:invalid_credentials) do
    {
      user: {
        email: ""
      }
    }.to_json
  end

  # User signup test suite
  describe 'POST /auth/signup' do
    context 'when valid request' do
      before { post '/auth/signup', params: { user: valid_attributes }.to_json, headers: headers }

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
          email: valid_attributes[:email],
          username: valid_attributes[:username],
          user_otp_secret_key: user.otp_secret_key,
          user_otp_module: user.otp_module,
          user_email_confirmation: valid_attributes[:confirmed_at],
          user_github_linked: user.provider?
        }
        expect(auth_user_obj).to eq user_obj
      end

      it_behaves_like 'returns 201 created status'
    end

    context 'when invalid request' do
      context "when invalid credentials" do
        before { post '/auth/signup', params: invalid_credentials, headers: headers }
        
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