module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end
  class MissingAcceptHeader < StandardError; end
  class WrongAcceptHeader < StandardError; end
  class InternalServerError < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidToken, with: :unauthorized_request
    rescue_from ExceptionHandler::ExpiredSignature, with: :unauthorized_request
    rescue_from ActiveRecord::RecordNotFound, with: :four_not_four
    rescue_from ActionController::InvalidAuthenticityToken, with: :csrf_invalid_request
    rescue_from ExceptionHandler::MissingAcceptHeader, with: :unauthorized_request
    rescue_from ExceptionHandler::WrongAcceptHeader, with: :unauthorized_request
    rescue_from ActionController::RoutingError, with: :four_not_four
    rescue_from ExceptionHandler::InternalServerError, with: :five_zero_zero
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    send_response = {
      status: 422,
      errors: {
        message: e.message
      }
    }
    json_response(send_response, :unprocessable_entity)
  end

  def csrf_invalid_request(e)
    send_response = {
      status: 422,
      errors: {
        message: Message.invalid_csrf_token
      }
    }
    json_response(send_response, :unprocessable_entity)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    send_response = {
      status: 401,
      errors: {
        message: e.message
      }
    }
    json_response(send_response, :unauthorized)
  end

  # JSON response with message; Status code 404 - not found
  def four_not_four(e)
    send_response = {
      status: 404,
      errors: {
        message: "#{e.message}. #{Message.action_not_found}"
      }
    }
    json_response(send_response, :not_found)
  end

  # JSON response with message; Status code 500 - internal server error
  def five_zero_zero(e)
    send_response = {
      status: 500,
      errors: {
        message: e.message
      }
    }
    json_response(send_response, :internal_server_error)
  end
end