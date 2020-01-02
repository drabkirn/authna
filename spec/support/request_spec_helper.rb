module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)
  end

  # generate tokens from user id
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  # generate expired tokens from user id
  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  def api_valid_headers
    {
      "Content-Type": "application/json",
      "Accept": "application/drabkirn.authna.v1",
      "Authorization": token_generator(user.id),
    }
  end

  def api_invalid_headers
    {
      "Content-Type": "application/json",
      "Accept": "application/drabkirn.authna.v1",
      "Authorization": nil,
    }
  end

  def api_valid_headers_without_authorization
    {
      "Content-Type": "application/json",
      "Accept": "application/drabkirn.authna.v1"
    }
  end

  def api_invalid_headers_with_empty_accept_header_without_authorization
    {
      "Content-Type": "application/json",
      "Accept": ""
    }
  end

  def api_invalid_headers_with_wrong_accept_header_without_authorization
    {
      "Content-Type": "application/json",
      "Accept": "application/drabkirn.authna.v11"
    }
  end

  def app_valid_headers
    {
      "Authorization" => token_generator(user.id),
      "Content-Type" => "application/json",
      "Accept" => "application/brinkirn.authna.v1"
    }
  end

  def app_invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "application/json",
      "Accept" => "application/brinkirn.authna.v1"
    }
  end

  def ui_valid_headers_without_authorization
    {
      "Accept": "application/drabkirn.authna.v1"
    }
  end


  def user_valid_email_credentials
    {
      "user": {
        "email": user.email,
        "password": user.password
      }
    }
  end

  def user_valid_username_credentials
    {
      "user": {
        "username": user.username,
        "password": user.password
      }
    }
  end

  def user_invalid_credentials
    {
      "user": {
        "email": Faker::Internet.email,
        "username": Faker::Internet.username,
        "password": Faker::Internet.password
      }
    }
  end
end