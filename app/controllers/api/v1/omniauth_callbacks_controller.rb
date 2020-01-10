class Api::V1::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # No need to check for `Authorization` header defined in `application_controller.rb`
  skip_before_action :authorize_request, only: :github

  # Authentication with GitHub
  def github
    user = User.from_omniauth(auth_param)
    auth_token = AuthenticateUser.new("", "", "", "", user).call[0]
    send_response = {
      status: 200,
      message: Message.user_successfully_authenticated,
      data: {
        auth_token: auth_token,
        id: user.id,
        email: user.email,
        username: user.username,
        first_name: user.first_name,
        last_name: user.last_name,
        admin: user.admin,
        otp_secret_key: user.otp_secret_key,
        otp_module: user.otp_module,
        email_confirmation: user.confirmed_at,
        github_linked: true
      }
    }
    json_response(send_response)
  end

  private

  def auth_param
    request.env["omniauth.auth"]
  end
end