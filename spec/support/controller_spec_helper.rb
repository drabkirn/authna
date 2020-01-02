module ControllerSpecHelper
  # generate tokens from user id
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  # generate expired tokens from user id
  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  # return valid headers
  def valid_headers
    {
      "Authorization" => token_generator(user.id),
      "Content-Type" => "application/json",
      "Accept" => "application/brinkirn.authza.v1"
    }
  end

  def valid_headers_with_user(user)
    {
      "Authorization" => token_generator(user.id),
      "Content-Type" => "application/json",
      "Accept" => "application/brinkirn.authza.v1"
    }
  end

  def valid_headers_without_authorization
    {
      "Content-Type" => "application/json",
      "Accept" => "application/brinkirn.authza.v1"
    }
  end

  # return invalid headers
  def invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "application/json",
      "Accept" => "application/brinkirn.authza.v1"
    }
  end

  def expired_token_headers
    {
      "Authorization" => expired_token_generator(user.id),
      "Content-Type" => "application/json",
      "Accept" => "application/brinkirn.authza.v1"
    }
  end
end