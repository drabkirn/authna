class Api::V1::ConfirmationsController < ApplicationController
  # Doing some strict validations for confirmationing user's email
  before_action :wrong_confirmation_token, only: [:show]
  before_action :wrong_email_request, only: [:create]

  # No need to check for `Authorization` header defined in `application_controller.rb`
  skip_before_action :authorize_request, only: [:show, :create]

  def show
    confirmation_token = params[:confirmation_token]
    user = User.find_by(confirmation_token: confirmation_token)
    user.confirm
    send_response = {
      status: 200,
      message: Message.email_successfully_confirmed(user.email),
      data: { }
    }
    json_response(send_response)
  end

  def create
    user_email = params[:user][:email]
    user = User.find_by(email: user_email)
    user.resend_confirmation_instructions
    send_response = {
      status: 200,
      message: Message.email_confirmation_resent(user_email),
      data: {}
    }
    json_response(send_response)
  end

  private
  
    def wrong_confirmation_token
      confirmation_token = params[:confirmation_token]
      if !confirmation_token.present?
        send_response = {
          status: 422,
          errors: {
            message: Message.email_missing_confirmation_token
          }
        }
        json_response(send_response, :unprocessable_entity)
      elsif !User.find_by(confirmation_token: confirmation_token).present?
        send_response = {
          status: 422,
          errors: {
            message: Message.email_wrong_confirmation_token
          }
        }
        json_response(send_response, :unprocessable_entity)
      end
    end

    def wrong_email_request
      user_email = params[:user][:email]
      confirm_user_email = params[:user][:confirm_email]
      user = User.find_by(email: user_email)
      if !user_email.present? || !confirm_user_email.present? || user_email != confirm_user_email
        send_response = {
          status: 422,
          errors: {
            message: Message.email_missing
          }
        }
        json_response(send_response, :unprocessable_entity)
      elsif !user.present?
        send_response = {
          status: 422,
          errors: {
            message: Message.user_does_not_exist
          }
        }
        json_response(send_response, :unprocessable_entity)
      elsif user.confirmed_at != nil
        send_response = {
          status: 422,
          errors: {
            message: Message.email_already_confirmed(user.email)
          }
        }
        json_response(send_response, :unprocessable_entity)
      end
    end
end
