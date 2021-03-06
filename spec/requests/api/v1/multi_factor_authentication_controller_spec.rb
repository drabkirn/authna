require 'rails_helper'

RSpec.describe Api::V1::MultiFactorAuthenticationController, type: :request do
  let(:user) { create(:confirmed_user) }
  let(:api_v_headers) { api_valid_headers }

  describe "enable 2FA, POST /auth/enable2fa" do
    context "when successfully enabled" do
      before(:each) do
        post api_auth_enable2fa_path, params: { multi_factor_authentication: { otp_code_token: user.otp_code } }.to_json, headers: api_v_headers
      end

      it "successfully enables and sends success message" do
        expect(json['message']).to eq Message.two_fa_enabled
      end

      it_behaves_like 'returns 200 success status'
    end

    context "when cannot be enabled" do
      context "when otp code token is not sent" do
        before(:each) do
          post api_auth_enable2fa_path, params: {}, headers: api_v_headers
        end

        it "returns not enabled message" do
          expect(json['errors']['message']).to eq Message.two_fa_not_enabled
        end

        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "when otp code token is empty" do
        before(:each) do
          post api_auth_enable2fa_path, params: { multi_factor_authentication: { otp_code_token: '' } }.to_json, headers: api_v_headers
        end

        it "returns not enabled message" do
          expect(json['errors']['message']).to eq Message.two_fa_not_enabled
        end

        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "when otp code token sent is wrong" do
        before(:each) do
          post api_auth_enable2fa_path, params: { multi_factor_authentication: { otp_code_token: '123456' } }.to_json, headers: api_v_headers
        end

        it "returns not enabled message" do
          expect(json['errors']['message']).to eq Message.two_fa_not_enabled
        end

        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "when user is authenticated with Github" do
        before(:each) do
          user.provider = "github"
          user.save
          post api_auth_enable2fa_path, params: { multi_factor_authentication: { otp_code_token: user.otp_code } }.to_json, headers: api_v_headers
        end

        it "returns not enabled message" do
          expect(json['errors']['message']).to eq Message.two_fa_not_enabled
        end

        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "with invalid authenticity token" do
        it_behaves_like 'when csrf token is not present', '/auth/enable2fa'
      end
    end
  end

  describe "disable 2FA, POST /auth/disable2fa" do
    context "when successfully disabled" do
      context "when disabled" do
        before(:each) do
          user.otp_module_enabled!
          @user_secret_key = user.otp_secret_key
          post api_auth_disable2fa_path, params: { multi_factor_authentication: { otp_code_token: user.otp_code } }.to_json, headers: api_v_headers
        end

        it "successfully disables and sends success message" do
          expect(json['message']).to eq Message.two_fa_disabled
        end

        it "regenerates the otp_secret_key" do
          user.reload
          expect(user.otp_secret_key).not_to eq @user_secret_key
        end

        it_behaves_like 'returns 200 success status'
      end
    end

    context "when cannot be disabled" do
      context "when otp code token is not sent" do
        before(:each) do
          user.otp_module_enabled!
          post api_auth_disable2fa_path, params: {}, headers: api_v_headers
        end

        it "returns not disabled message" do
          expect(json['errors']['message']).to eq Message.two_fa_not_disabled
        end

        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "when otp code token is empty" do
        before(:each) do
          user.otp_module_enabled!
          post api_auth_disable2fa_path, params: { multi_factor_authentication: { otp_code_token: '' } }.to_json, headers: api_v_headers
        end

        it "returns not disabled message" do
          expect(json['errors']['message']).to eq Message.two_fa_not_disabled
        end

        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "when otp code token sent is wrong" do
        before(:each) do
          user.otp_module_enabled!
          post api_auth_disable2fa_path, params: { multi_factor_authentication: { otp_code_token: '123456' } }.to_json, headers: api_v_headers
        end

        it "returns not disabled message" do
          expect(json['errors']['message']).to eq Message.two_fa_not_disabled
        end

        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "when user is authenticated with Github" do
        before(:each) do
          user.provider = "github"
          user.save
          post api_auth_disable2fa_path, params: { multi_factor_authentication: { otp_code_token: user.otp_code } }.to_json, headers: api_v_headers
        end

        it "returns not enabled message" do
          expect(json['errors']['message']).to eq Message.two_fa_not_disabled
        end

        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "with invalid authenticity token" do
        it_behaves_like 'when csrf token is not present', '/auth/disable2fa'
      end
    end
  end
end
