class Api::V1::AppzasController < ApplicationController
  # No need to check for `Authorization` header defined in `application_controller.rb`
  skip_before_action :authorize_request, only: [:show]

  def show
    @appza = Appza.find(params[:id])
    send_response = {
      status: 200,
      message: Message.appza_show_loaded(@appza.id),
      data: {
        name: @appza.name,
        url: @appza.url,
        requires: @appza.requires
      }
    }
    json_response(send_response)
  end
end
