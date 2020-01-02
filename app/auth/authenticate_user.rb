class AuthenticateUser
  # User can be authenticated with the following: email, username or gitHub
  def initialize(email, password, username = "", otp_code_token = "", github_user = "")
    @email = email
    @password = password
    @username = username
    @otp_code_token = otp_code_token
    @github_user = github_user
  end

  # Entry point to encode the Token
  def call
    return JsonWebToken.encode(user_id: user.id), user if user
  end

  private

  attr_reader :email, :password, :username, :otp_code_token, :github_user

  # Verify user credentials
  def user
    return github_user if github_user.present?
    if username.present?
      user = User.find_by(username: username)
      if user && user.otp_module_enabled?
        if !otp_code_token
          raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
        end
        auth_user = User.authenticate("", password, username)
        auth_user_with_token = auth_user.authenticate_otp(otp_code_token, drift: 60).present?
        return user if auth_user && auth_user_with_token
      else
        return user if user && User.authenticate("", password, username)
      end
    else
      user = User.find_by(email: email)
      if user && user.otp_module_enabled?
        if !otp_code_token
          raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
        end
        auth_user = User.authenticate(email, password)
        auth_user_with_token = auth_user.authenticate_otp(otp_code_token, drift: 60).present?
        return user if auth_user && auth_user_with_token
      else
        return user if user && User.authenticate(email, password)
      end
    end
    # raise Authentication error if credentials are invalid
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end