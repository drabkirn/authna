class Api::V1::AuthenticationController < ApplicationController
  # No need to check for `Authorization` header defined in `application_controller.rb`
  skip_before_action :authorize_request, only: :authenticate
  
  # Check for authentication and send back auth_token if correct
  # If authentication is wrong, returns errors defined in `auth/authenticate_user.rb`
  def authenticate
    if auth_params[:email].present?
      auth_token, user = AuthenticateUser.new(auth_params[:email], auth_params[:password], "", auth_params[:otp_code_token], "").call
    else
      auth_token, user = AuthenticateUser.new("", auth_params[:password], auth_params[:username], auth_params[:otp_code_token], "").call
    end
    send_response = {
      status: 200,
      message: Message.user_successfully_authenticated,
      data: {
        auth_token: auth_token
      }
    }
    json_response(send_response)
  end

  private

  def auth_params
    params.require(:user).permit(:email, :password, :username, :otp_code_token)
  end
end
