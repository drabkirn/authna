class ApplicationController < ActionController::Base
  # Include our /concerns helpers module
  include Response
  include ExceptionHandler

  # called before every action on controllers
  before_action :authorize_request
  attr_reader :current_user

  # Skip CSRF tokens when testing the API from CURL, not to be used in production
  skip_before_action :verify_authenticity_token if Rails.env.development?

  private

  # Check for valid request token and return user
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end
end
