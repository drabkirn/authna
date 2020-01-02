class Api::V1::UsersController < ApplicationController
  # No need to check for `Authorization` header defined in `application_controller.rb`
  skip_before_action :authorize_request, only: :create

  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password, "", "", "").call[0]
    send_response = {
      status: 201,
      data: {
        auth_token: auth_token,
        message: Message.user_account_created,
        user_id: user.id,
        user_email: user.email,
        user_username: user.username,
        user_otp_secret_key: user.otp_secret_key,
        user_otp_module: user.otp_module,
        user_email_confirmation: user.confirmed_at,
        user_github_linked: false
      }
    }
    json_response(send_response, :created)
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :username,
      :password,
      :password_confirmation
    )
  end
end
