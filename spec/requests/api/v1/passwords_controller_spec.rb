require 'rails_helper'

RSpec.describe Api::V1::PasswordsController, type: :request do
  let(:user) { create(:confirmed_user) }
  let(:api_v_headers) { api_valid_headers_without_authorization }

  describe "POST #forget" do
    context "when request is valid" do
      before(:each) do
        post api_auth_password_forgot_path, params: { user: { email: user.email } }.to_json, headers: api_v_headers
      end

      it "returns password_reset_message_sent message" do
        expect(json['message']).to eq Message.password_reset_message_sent
      end

      it_behaves_like 'returns 200 success status'
    end

    context "when request is invalid" do
      before(:each) do
        post api_auth_password_forgot_path, params: { user: { email: "" } }.to_json, headers: api_v_headers
      end

      it "returns user_does_not_exist message" do
        expect(json['errors']['message']).to eq Message.user_does_not_exist
      end

      it_behaves_like 'returns 422 unprocessable entity status'
    end

    context "with invalid authenticity token" do
      it_behaves_like 'when csrf token is not present', '/auth/password/forgot'
    end
  end

  describe "POST #recover" do
    context "when request is valid" do
      before(:each) do
        user.reset_password_token = Devise.friendly_token(40)
        user.reset_password_sent_at = Time.now
        user.save
        post api_auth_password_recover_path, params: { user: { recovery_token: user.reset_password_token, password: "1234567890", password_confirmation: "1234567890" } }.to_json, headers: api_v_headers
      end

      it "resets reset_password_token of user" do
        user.reload
        expect(user.reset_password_token).to eq nil
      end

      it "resets reset_password_sent_at of user" do
        user.reload
        expect(user.reset_password_sent_at).to eq nil
      end

      it "returns password_reset_success message" do
        expect(json['message']).to eq Message.password_reset_success
      end

      it_behaves_like 'returns 200 success status'
    end

    context "when request is invalid" do
      before(:each) do
        user.reset_password_token = Devise.friendly_token(40)
        user.reset_password_sent_at = Time.now
        user.save
      end

      context "when recovery token is not present/blank" do
        before(:each) do
          post api_auth_password_recover_path, params: { user: { password: "1234567890", password_confirmation: "1234567890" } }.to_json, headers: api_v_headers
        end

        it "returns recovery_token_not_present message" do
          expect(json['errors']['message']).to eq Message.recovery_token_not_present
        end
  
        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "when recovery token is wrong" do
        before(:each) do
          post api_auth_password_recover_path, params: { user: { recovery_token: "abcd", password: "1234567890", password_confirmation: "1234567890" } }.to_json, headers: api_v_headers
        end

        it "returns wrong_recovery_token message" do
          expect(json['errors']['message']).to eq Message.recovery_token_wrong
        end
  
        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "when something is wrong with data - not same passwords" do
        before(:each) do
          post api_auth_password_recover_path, params: { user: { recovery_token: user.reset_password_token, password: "1234567890", password_confirmation: "12345678" } }.to_json, headers: api_v_headers
        end

        it "returns password_reset_failure message" do
          expect(json['errors']['message']).to eq Message.password_reset_failure
        end
  
        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "with invalid authenticity token" do
        it_behaves_like 'when csrf token is not present', '/auth/password/recover'
      end
    end
  end
end
