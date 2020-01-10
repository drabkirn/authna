require 'rails_helper'

RSpec.describe Api::V1::ConfirmationsController, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:api_v_headers) { api_valid_headers_without_authorization }

  describe "GET #show" do
    context "when confirmation_token is correct" do
      before(:each) do
        get user_confirmation_path, params: { confirmation_token: user.confirmation_token }, headers: api_v_headers
      end
      
      it "renders that user has confirmed the email" do
        expect(json['message']).to eq Message.email_successfully_confirmed(user.email)
      end
      
      it_behaves_like 'returns 200 success status'
    end
    
    context "when confirmation token is not sent" do
      before(:each) do
        get user_confirmation_path, headers: api_v_headers
      end
      
      it "renders error if confirmation_token is not present" do
        expect(json['errors']['message']).to eq Message.email_missing_confirmation_token
      end
      
      it_behaves_like 'returns 422 unprocessable entity status'
    end
    
    context "when confirmation_token is incorrect" do
      before(:each) do
        get user_confirmation_path, params: { confirmation_token: "abcdefgh" }, headers: api_v_headers
      end
      
      it "renders error if wrong confirmation_token is sent" do
        expect(json['errors']['message']).to eq Message.email_wrong_confirmation_token
      end
      
      it_behaves_like 'returns 422 unprocessable entity status'
    end
  end

  describe "POST #create" do
    context "when email resend request is correct" do
      before(:each) do
        post user_confirmation_path, params: { user: { email: user.email, confirm_email: user.email } }.to_json, headers: api_v_headers
      end
      
      it "renders that email confirmation has been sent" do
        expect(json['message']).to eq Message.email_confirmation_resent(user.email)
      end
      
      it_behaves_like 'returns 200 success status'
    end

    context "when email resend request is wrong" do
      context "when email or confirm_email is not present" do
        before(:each) do
          post user_confirmation_path, params: { user: { email: user.email, confirm_email: "" } }.to_json, headers: api_v_headers
        end
        
        it "renders that email is wrong" do
          expect(json['errors']['message']).to eq Message.email_missing
        end
        
        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "when email and confirm_email don't match" do
        before(:each) do
          post user_confirmation_path, params: { user: { email: user.email, confirm_email: "abcd@efgh.com" } }.to_json, headers: api_v_headers
        end
        
        it "renders that email is wrong" do
          expect(json['errors']['message']).to eq Message.email_missing
        end
        
        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "when user is not present" do
        before(:each) do
          post user_confirmation_path, params: { user: { email: "abcd@efgh.com", confirm_email: "abcd@efgh.com" } }.to_json, headers: api_v_headers
        end
        
        it "renders error that user does not exist" do
          expect(json['errors']['message']).to eq Message.user_does_not_exist
        end
        
        it_behaves_like 'returns 422 unprocessable entity status'
      end

      context "when users email is already confirmed" do
        before(:each) do
          @confirmed_user = FactoryBot.create :confirmed_user
          post user_confirmation_path, params: { user: { email: @confirmed_user.email, confirm_email: @confirmed_user.email } }.to_json, headers: api_v_headers
        end
        
        it "renders error that user's email is already confirmed" do
          expect(json['errors']['message']).to eq Message.email_already_confirmed(@confirmed_user.email)
        end
        
        it_behaves_like 'returns 422 unprocessable entity status'
      end
    end

    context "with invalid authenticity token" do
      it_behaves_like 'when csrf token is not present', '/users/confirmation'
    end
  end
end
