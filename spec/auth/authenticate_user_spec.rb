require 'rails_helper'

RSpec.describe AuthenticateUser do
  # create test user
  let(:user) { create(:confirmed_user) }
  # valid request subject
  subject(:valid_auth_obj) { described_class.new(user.email, user.password, "", "", "") }
  # valid 2fa subject
  subject(:valid_auth_2fa_email_obj) { described_class.new(user.email, user.password, "", user.otp_code, "") }
  subject(:valid_auth_2fa_username_obj) { described_class.new("", user.password, user.username, user.otp_code, "") }
  subject(:invalid_auth_2fa_email_obj) { described_class.new(user.email, user.password, "", nil, "") }
  subject(:invalid_auth_2fa_username_obj) { described_class.new("", user.password, user.username, nil, "") }
  # invalid request subject
  subject(:invalid_auth_obj) { described_class.new('foo', 'bar', "", "", "") }

  # Test suite for AuthenticateUser#call
  describe '#call' do
    # return token when valid request
    context 'when valid credentials' do
      it 'returns an auth token' do
        token = valid_auth_obj.call[0]
        expect(token).not_to be_nil
      end

      it 'returns user data' do
        auth_user = valid_auth_obj.call[1]
        auth_user_obj = {
          id: auth_user.id,
          email: auth_user.email,
          user_email_confirmation: auth_user.confirmed_at
        }
        user_obj = {
          id: user.id,
          email: user.email,
          user_email_confirmation: user.confirmed_at
        }
        expect(auth_user_obj).to eq user_obj
      end

      it 'returns user data when 2fa enabled with email login' do
        user.otp_module_enabled!
        auth_user = valid_auth_2fa_email_obj.call[1]
        auth_user_obj = {
          id: auth_user.id,
          email: auth_user.email,
          user_email_confirmation: auth_user.confirmed_at
        }
        user_obj = {
          id: user.id,
          email: user.email,
          user_email_confirmation: user.confirmed_at
        }
        expect(auth_user_obj).to eq user_obj
      end

      it 'returns user data when 2fa enabled with email login' do
        user.otp_module_enabled!
        auth_user = valid_auth_2fa_username_obj.call[1]
        auth_user_obj = {
          id: auth_user.id,
          email: auth_user.email,
          user_email_confirmation: auth_user.confirmed_at
        }
        user_obj = {
          id: user.id,
          email: user.email,
          user_email_confirmation: user.confirmed_at
        }
        expect(auth_user_obj).to eq user_obj
      end
    end

    # raise Authentication Error when invalid request
    context 'when invalid credentials' do
      it 'raises an authentication error' do
        expect { invalid_auth_obj.call }
          .to raise_error(
            ExceptionHandler::AuthenticationError,
            Message.invalid_credentials
          )
      end

      it "raises auth error for email if otp credentials are not present" do
        user.otp_module_enabled!
        expect { invalid_auth_2fa_email_obj.call }.to raise_error(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
      end

      it "raises auth error for username if otp credentials are not present" do
        user.otp_module_enabled!
        expect { invalid_auth_2fa_username_obj.call }.to raise_error(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
      end
    end
  end
end