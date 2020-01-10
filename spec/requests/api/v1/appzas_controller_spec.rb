require 'rails_helper'

RSpec.describe Api::V1::AppzasController, type: :request do
  let(:appza) { create(:appza) }
  let(:appza2) { create(:appza, callback_url: "https://drabkirn.authna", accept_header: "accept_all") }
  let(:appza3) { create(:appza, callback_url: "https://drabkirn.authna.invalid", accept_header: "accept_all") }
  let(:appza4) { create(:appza, callback_url: "https://drabkirn.authna.invalid2", accept_header: "accept_all") }
  let!(:user) { create(:user) }
  let(:api_v_headers) { api_valid_headers_without_authorization }
  
  let(:api_v_headers_with_auth) do
    {
      "Authorization" => token_generator(appza2.user.id),
      "Content-Type" => "application/json",
      "Accept" => "application/drabkirn.authna.v1"
    }
  end

  let(:api_v_headers_with_auth_appza3) do
    {
      "Authorization" => token_generator(appza3.user.id),
      "Content-Type" => "application/json",
      "Accept" => "application/drabkirn.authna.v1"
    }
  end

  let(:api_v_headers_with_auth_appza4) do
    {
      "Authorization" => token_generator(appza4.user.id),
      "Content-Type" => "application/json",
      "Accept" => "application/drabkirn.authna.v1"
    }
  end

  let(:appza_v_credentials) do
    {
      appza: {
        id: appza2.id
      }
    }
  end

  let(:appza_inv_credentials) do
    {
      appza: {
        id: appza3.id
      }
    }
  end

  let(:appza_inv_credentials2) do
    {
      appza: {
        id: appza4.id
      }
    }
  end

  describe "GET /authza/:id" do
    context "when valid request" do
      before do
        get api_appza_path(appza.id), params: { }, headers: api_v_headers
      end

      it 'returns success message' do
        expect(json['message']).to eq Message.appza_show_loaded(appza.id)
      end

      it 'returns appza data of particular ID' do
        expect(json['data']['name']).to eq appza.name
        expect(json['data']['url']).to eq appza.url
        expect(json['data']['requires']).to eq appza.requires
      end

      it_behaves_like 'returns 200 success status'
    end
  end

  describe "POST /auth/appzas/login" do
    context 'When request is valid users auth_token' do
      before do
        post api_auth_appzas_login_path, params: appza_v_credentials.to_json, headers: api_v_headers_with_auth
      end

      it 'returns appza successfully authenticated message' do
        expect(json['message']).to eq Message.appza_user_successfully_authenticated
      end

      it_behaves_like 'returns 200 success status'
    end

    context 'when request is invalid - Remote Error' do
      before do
        post api_auth_appzas_login_path, params: appza_inv_credentials.to_json, headers: api_v_headers_with_auth_appza3
      end

      it 'returns a failure message' do
        expect(json['errors']['message']).to eq Message.appza_user_authentication_failed
      end

      it_behaves_like 'returns 422 unprocessable entity status'
    end

    context 'when request is invalid - Standard error' do
      before do
        post api_auth_appzas_login_path, params: appza_inv_credentials2.to_json, headers: api_v_headers_with_auth_appza4
      end

      it 'returns a failure message' do
        expect(json['errors']['message']).to eq Message.appza_user_authentication_failed
      end

      it_behaves_like 'returns 422 unprocessable entity status'
    end
  end
end
