class ApplicationController < ActionController::Base
  # Include our /concerns helpers module
  include Response
  include ExceptionHandler

  # Check Accept Header for API requests
  before_action :accept_header_check_for_api_requests

  # called before every action on controllers
  before_action :authorize_request
  attr_reader :current_user

  # Skip CSRF tokens when testing the API from CURL, not to be used in production
  skip_before_action :verify_authenticity_token if Rails.env.development?

  # When making invalid API-only requests, raise 404
  def action_not_found
    raise(ActionController::RoutingError, Message.action_not_found)
  end

  # When something is wrong in the app/server - API-only, raise 500
  def internal_server_error
    raise(ExceptionHandler::InternalServerError, Message.internal_server_error)
  end

  private

  # Check for valid request token and return user
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  def accept_header_check_for_api_requests
    is_api_request = ApiRequestCheck.new.matches?(request)
    if is_api_request
      accept_header = request.headers["Accept"]
      accept_version = "v1"
      if accept_header.present?
        raise(ExceptionHandler::WrongAcceptHeader, Message.accept_header_wrong) if accept_header != "application/drabkirn.authna.#{accept_version}"
      else
        raise(ExceptionHandler::MissingAcceptHeader, Message.accept_header_missing)
      end
    end
  end
end
