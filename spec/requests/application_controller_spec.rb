require "rails_helper"

RSpec.describe ApplicationController, type: :request do
  # create test user
  let!(:user) { create(:user) }
   # set headers for authorization
  let(:api_v_headers) { api_valid_headers }
  let(:ui_v_headers) { ui_valid_headers_without_authorization }

  describe "#authorize_request" do
    context "when auth token is passed" do
      before { allow(request).to receive(:headers).and_return(app_valid_headers) }

      # private method authorize_request returns current user
      it "sets the current user" do
        p request.headers
        expect(subject.instance_eval { authorize_request }).to eq(user)
      end
    end

    context "when auth token is not passed" do
      before do
        allow(request).to receive(:headers).and_return(app_invalid_headers)
      end

      it "raises MissingToken error" do
        expect { subject.instance_eval { authorize_request } }.
          to raise_error(ExceptionHandler::MissingToken, Message.missing_authorization_token)
      end
    end
  end

  describe "check if an request is an API request or UI request" do
    context "check for API request" do
      before(:each) do
        my_user = create(:user)
        user_valid_credential = {
          user: {
            email: user.email,
            password: "12345678"
          }
        }.to_json
        # test with login action
        post '/auth/login', params: user_valid_credential, headers: api_v_headers
      end

      it 'returns an authentication token' do
        expect(json['data']['auth_token']).not_to be_nil
      end

      it 'returns successfully authenticated message' do
        expect(json['data']['message']).to eq Message.user_successfully_authenticated
      end

      it "returns application/json content type in response header" do
        content_type_response_header = response.headers["Content-Type"]
        expect(content_type_response_header).to eq "application/json; charset=utf-8"
      end

      it "returns true for ApiRequest check" do
        expect(ApiRequestCheck.new.matches?(request)).to eq true
      end

      it_behaves_like "returns 200 success status"
    end

    context "check for UI request" do
      before(:each) do
        get '/', params: {}, headers: ui_v_headers
      end

      it "returns text/html content type in response header" do
        content_type_response_header = response.headers["Content-Type"]
        expect(content_type_response_header).to eq "text/html; charset=utf-8"
      end

      it "returns true for UiRequest check" do
        expect(UiRequestCheck.new.matches?(request)).to eq true
      end

      it "returns 200 success status from response" do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "#accept_header_check_for_api_requests" do
    context "when there is no Accept header" do
      before(:each) do
        my_user = create(:user)
        user_valid_credential = {
          user: {
            email: user.email,
            password: "12345678"
          }
        }.to_json
        # test with login action of user
        post '/auth/login', params: user_valid_credential, headers: api_invalid_headers_with_empty_accept_header_without_authorization
      end

      it "returns missing accept header message" do
        expect(json['errors']['message']).to match(Message.accept_header_missing)
      end

      it_behaves_like 'returns 401 unauthorized status'
    end

    context "when there is wrong Accept header" do
      before(:each) do
        my_user = create(:user)
        user_valid_credential = {
          user: {
            email: user.email,
            password: "12345678"
          }
        }.to_json
        # test with login action of user
        post '/auth/login', params: user_valid_credential, headers: api_invalid_headers_with_wrong_accept_header_without_authorization
      end

      it "returns wrong accept header message" do
        expect(json['errors']['message']).to match(Message.accept_header_wrong)
      end

      it_behaves_like 'returns 401 unauthorized status'
    end
  end

  describe "action_not_found when making API invalid requests" do
    context "when making a invalid request - application wide" do
      before(:each) do
        get '/xyz_invalid_request', params: {}, headers: api_v_headers
      end

      it_behaves_like "returns 404 not found status"
    end

    context "when making a invalid request - on /404" do
      before(:each) do
        get '/404', params: {}, headers: api_v_headers
      end

      it_behaves_like "returns 404 not found status"
    end
  end

  describe "internal_server_error - application wide" do
    before(:each) do
      get '/500', params: {}, headers: api_valid_headers
    end

    it_behaves_like "returns 500 internal server error status"
  end
end