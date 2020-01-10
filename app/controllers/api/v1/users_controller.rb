class Api::V1::UsersController < ApplicationController
  # No need to check for `Authorization` header defined in `application_controller.rb`
  skip_before_action :authorize_request, only: :create

  # Creating a new user
  # Raises ActiveRecord::RecordInvalid if something is wrong
  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password, "", "", "").call[0]
    send_response = {
      status: 201,
      message: Message.user_account_created,
      data: {
        auth_token: auth_token
      }
    }
    json_response(send_response, :created)
  end

  # Authenticate the user, Show it's details
  def show
    send_response = {
      status: 200,
      message: Message.user_loaded(@current_user.id),
      data: {
        id: @current_user.id,
        email: @current_user.email,
        username: @current_user.username,
        first_name: @current_user.first_name,
        last_name: @current_user.last_name,
        admin: @current_user.admin,
        otp_secret_key: @current_user.otp_secret_key,
        otp_module: @current_user.otp_module,
        email_confirmation: @current_user.confirmed_at,
        github_linked: false
      }
    }
    json_response(send_response)
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :username,
      :first_name,
      :last_name,
      :password,
      :password_confirmation
    )
  end
end
