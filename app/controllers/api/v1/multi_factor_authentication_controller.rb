class Api::V1::MultiFactorAuthenticationController < ApplicationController
  def verify_enable
    otp_param = params[:multi_factor_authentication][:otp_code_token]
    if otp_param && current_user && !current_user.provider? && current_user.authenticate_otp(otp_param, drift: 60).present?
      current_user.otp_module_enabled!
      send_response = {
        status: 200,
        data: {
          message: Message.two_fa_enabled
        }
      }
      json_response(send_response)
    else
      send_response = {
        status: 422,
        errors: {
          message: Message.two_fa_not_enabled
        }
      }
      json_response(send_response, :unprocessable_entity)
    end
  end

  def verify_disabled
    otp_param = params[:multi_factor_authentication][:otp_code_token]
    if otp_param && current_user && !current_user.provider? && current_user.authenticate_otp(params[:multi_factor_authentication][:otp_code_token], drift: 60).present?
      current_user.otp_module_disabled!
      current_user.otp_regenerate_secret
      current_user.save
      send_response = {
        status: 200,
        data: {
          message: Message.two_fa_disabled
        }
      }
      json_response(send_response)
    else
      send_response = {
        status: 422,
        errors: {
          message: Message.two_fa_not_disabled
        }
      }
      json_response(send_response, :unprocessable_entity)
    end
  end
end
