class Api::V1::PasswordsController < ApplicationController
  # Doing some strict validation
  before_action :wrong_recovery_token, only: [:recover]

  # No need to check for `Authorization` header defined in `application_controller.rb`
  skip_before_action :authorize_request, only: [:forgot, :recover]

  def forgot
    user_email = params[:user][:email]
    user = User.find_by(email: user_email)
    if user.present?
      user.reset_password_token = Devise.friendly_token(40)
      user.reset_password_sent_at = Time.now
      user.save
      PasswordMailer.forget_email(user).deliver_now
      send_response = {
        status: 200,
        data: {
          user_email: user.email,
          message: Message.password_reset_message_sent
        }
      }
      json_response(send_response)
    else
      send_response = {
        status: 422,
        errors: {
          message: Message.user_does_not_exist
        }
      }
      json_response(send_response, :unprocessable_entity)
    end
  end

  def recover
    recovery_token = params[:user][:recovery_token]
    user = User.find_by(reset_password_token: recovery_token)
    user.reset_password_token = nil
    user.reset_password_sent_at = nil
    if user.update(user_params)
      send_response = {
        status: 200,
        data: {
          message: Message.password_reset_success
        }
      }
      json_response(send_response)
    else
      send_response = {
        status: 422,
        errors: {
          message: Message.password_reset_failure
        }
      }
      json_response(send_response, :unprocessable_entity)
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :password,
      :password_confirmation
    )
  end

  def wrong_recovery_token
    recovery_token = params[:user][:recovery_token]
    if !recovery_token.present?
      send_response = {
        status: 422,
        errors: {
          message: Message.recovery_token_not_present
        }
      }
      json_response(send_response, :unprocessable_entity)
    elsif !User.find_by(reset_password_token: recovery_token).present?
      send_response = {
        status: 422,
        errors: {
          message: Message.recovery_token_wrong
        }
      }
      json_response(send_response, :unprocessable_entity)
    end
  end
end
