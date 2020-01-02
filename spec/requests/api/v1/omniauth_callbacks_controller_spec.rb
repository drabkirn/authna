require 'rails_helper'

RSpec.describe Api::V1::OmniauthCallbacksController, type: :request do

  let(:headers) { invalid_headers }

  describe "Github Authentication" do
    context "when success authentication" do
      before(:each) do
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
          provider: 'github',
          uid: '123545',
          info: {
            email: Faker::Internet.email,
            nickname: Faker::Internet.username(specifier: 3..10, separators: %w(_))
          }
        })
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
        get '/users/auth/github/callback', params: { }, headers: headers
      end

      after(:each) do
        OmniAuth.config.test_mode = false
      end

      # TODO: Add full object test here

      it "successfully sends authenticated message" do
        expect(json['data']['message']).to eq Message.user_successfully_authenticated
      end

      it_behaves_like 'returns 200 success status'
    end
  end
end