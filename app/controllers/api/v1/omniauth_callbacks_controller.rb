class Api::V1::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # No need to check for `Authorization` header defined in `application_controller.rb`
  skip_before_action :authorize_request, only: :github

  # Authentication with GitHub
  def github
    user = User.from_omniauth(auth_param)
    auth_token = AuthenticateUser.new("", "", "", "", user).call[0]
    send_response = {
      status: 200,
      data: {
        auth_token: auth_token,
        message: Message.user_successfully_authenticated,
        user_id: user.id,
        user_email: user.email,
        user_username: user.username,
        user_otp_secret_key: user.otp_secret_key,
        user_otp_module: user.otp_module,
        user_email_confirmation: user.confirmed_at,
        user_github_linked: true
      }
    }
    json_response(send_response)
  end

  private

  def auth_param
    request.env["omniauth.auth"]
  end
end