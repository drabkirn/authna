require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let(:user2) { build(:user) }
  let(:user) { create(:user) }
  let(:api_v_headers) { api_valid_headers_without_authorization }
  let(:api_v_headers_with_auth) { api_valid_headers }
  let(:user_valid_email_credentials) do
    attributes_for(:user, password_confirmation: user2.password)
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
        expect(json['message']).to eq Message.user_account_created
      end

      it 'returns an authentication token' do
        expect(json['data']['auth_token']).not_to be_nil
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

  describe 'GET /users/:id' do
    context 'when valid request' do
      before do
        get api_users_show_path, params: { }, headers: api_v_headers_with_auth
      end

      it 'returns success message' do
        expect(json['message']).to eq Message.user_loaded(user.id)
      end

      it 'returns an requested user email' do
        expect(json['data']['email']).to eq user.email
      end

      it 'returns an requested user first_name' do
        expect(json['data']['first_name']).to eq user.first_name
      end

      it_behaves_like 'returns 200 success status'
    end
  end
end