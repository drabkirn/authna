class Api::V1::AppzasController < ApplicationController
  # No need to check for `Authorization` header defined in `application_controller.rb`
  skip_before_action :authorize_request, only: [:show]
  before_action :require_admin, only: [:index, :create]

  # Show admin users all Appza details
  def index
    @appzas = @current_user.appzas
    send_response = {
      status: 200,
      message: Message.appzas_loaded,
      data: @appzas
    }
    json_response(send_response)
  end

  def create
    @appza = Appza.new(appza_create_params)
    @appza.user = @current_user
    if @appza.save
      send_response = {
        status: 201,
        message: Message.appza_created(@appza.id),
        data: {
          id: @appza.id
        }
      }
      json_response(send_response, :created)
    else
      send_response = {
        status: 422,
        errors: {
          message: Message.appza_creation_failed(@appza.errors.full_messages)
        }
      }
      json_response(send_response, :unprocessable_entity)
    end
  end

  # Show info about Appza, doesn't include secret data
  def show
    @appza = Appza.find(params[:id])
    send_response = {
      status: 200,
      message: Message.appza_show_loaded(@appza.id),
      data: {
        id: @appza.id,
        name: @appza.name,
        url: @appza.url,
        requires: @appza.requires
      }
    }
    json_response(send_response)
  end

  # Authenticate current_user
  # Make request to external service with requested info
  def authenticate
    @appza = Appza.find(appza_params[:id])
    auth_token = request.headers['Authorization'].split(' ').last

    response_code = make_request_to_appza_callback(@appza, @current_user, auth_token)

    if(response_code == 200)
      send_response = {
        status: 200,
        message: Message.appza_user_successfully_authenticated,
        data: {}
      }
      json_response(send_response)
    else
      send_response = {
        status: 422,
        errors: {
          message: Message.appza_user_authentication_failed
        }
      }
      json_response(send_response, :unprocessable_entity)
    end
  end

  private

  def appza_params
    params.require(:appza).permit(:id)
  end

  def appza_create_params
    params.require(:appza).permit(:name, :url, :callback_url, :accept_header, requires: [])
  end

  def require_admin
    if !@current_user.admin
      send_response = {
        status: 401,
        errors: {
          message: Message.require_admin
        }
      }
      json_response(send_response, :unauthorized)
    end
  end

  def make_request_to_appza_callback(appza, current_user, auth_token)
    require 'uri'
    require 'net/http'
    require 'json'

    begin
      uri = URI(appza.callback_url)
      request = Net::HTTP::Post.new(uri.request_uri)
      # Request headers
      request['Content-Type'] = 'application/json'
      request['User-Agent'] = 'Drabkirn Authna : Official Website : NA'
      request['Accept'] = appza.accept_header
      request['AppzaSecret'] = appza.secret

      # Request body
      user_info = {
        auth_token: auth_token,
        id: current_user.id,
        email: (current_user.email if appza.requires.include?("email")),
        username: (current_user.username if appza.requires.include?("username"))
      }.compact

      myBody = {
        user: user_info
      }.to_json

      request.body = myBody

      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
      end

      response_code = JSON.parse(response.code)

      return response_code
    rescue StandardError
      return 422
    end
  end
end
