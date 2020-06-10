class Message
  # Users Login/Signup Messages
  def self.user_account_created
    "Your account has been successfully created. Don't forget to confirm your email."
  end

  def self.invalid_credentials
    "Exception: Invalid credentials, please check your email, password and OTP token(if 2FA enabled) and try again."
  end

  def self.user_successfully_authenticated
    "Successfully Authenticated. Also, You are now logged in."
  end

  def self.user_does_not_exist
    "Error: User not found in our records."
  end

  def self.user_loaded(id)
    "User with ID: #{id} loaded."
  end

  def self.require_admin
    "Admin is required to perform such actions."
  end

  # API Messages
  def self.invalid_authorization_token
    "Exception: Invalid Authorization token. Not enough or too many segments."
  end

  def self.missing_authorization_token
    "Exception: Missing Authorization token."
  end

  def self.expired_authorization_token
    "Signature has expired, thus your token has expired. Please login again to continue."
  end

  def self.accept_header_wrong
    "Exception: You've included wrong Accept header in your request."
  end

  def self.accept_header_missing
    "Exception: You've not included a valid Accept header in your request."
  end

  # Emails
  def self.email_successfully_confirmed(email)
    "You've successfully confirmed your email at #{email}. Close this window and continue signing in to the app."
  end

  def self.email_already_confirmed(email)
    "Oops, maybe you re-reached here. Your email at #{email} is already confirmed in our records."
  end

  def self.email_confirmation_resent(email)
    "Confirmation email successfully sent to #{email}."
  end

  def self.email_missing
    "Error: Email address or email confirmation is not present in your request."
  end

  def self.email_missing_confirmation_token
    "Error: Email confirmation token is not present in your request."
  end

  def self.email_wrong_confirmation_token
    "Error: You've used wrong or expired confirmation token in your request. Please re-confirm your email from login page."
  end

  # 2FA Messages
  def self.two_fa_enabled
    "Two factor authentication successfully enabled."
  end

  def self.two_fa_disabled
    "Two factor authentication successfully disabled."
  end

  def self.two_fa_not_enabled
    "Error: Two factor authentication could not be enabled."
  end

  def self.two_fa_not_disabled
    "Error: Two factor authentication could not be disabled."
  end

  # Password reset and recovery Messages
  def self.password_reset_message_sent
    "Please check your mail. We've sent the confirmation email to reset your password."
  end

  def self.password_reset_success
    "Your password has been reset. Now you can use new password to login."
  end

  def self.password_reset_failure
    "Error: There's something wrong and we couldn't reset your password."
  end

  def self.recovery_token_not_present
    "Recovery token is not present"
  end

  def self.recovery_token_wrong
    "Invalid recovery token. Please check the token and try again."
  end

  # Appza Messages
  def self.appzas_loaded
    "All appzas loaded."
  end

  def self.appza_show_loaded(id)
    "Appza with ID: #{id} loaded."
  end

  def self.appza_created(id)
    "Appza with ID: #{id} successfully created."
  end

  def self.appza_creation_failed(messages)
    "Error: Appza could not be created. #{messages.join(", ")}"
  end

  def self.appza_user_successfully_authenticated
    "Appza user has been successfully authenticated."
  end

  def self.appza_user_authentication_failed
    "Error: Authentication failed - Remote Error."
  end

  # Model Validation Messages
  def self.valid_https_url
    "Must be a valid HTTPS URL."
  end

  def self.valid_hosts_url
    "URL must have a valid host."
  end

  def self.must_be_admin
    "User must be an admin for this operation."
  end

  # Others, System messages
  def self.invalid_csrf_token
    "Exception: You're not authorized to make this request - CSRF Error."
  end

  def self.action_not_found
    "Error: 404 Not found."
  end

  def self.internal_server_error
    "Exception: 500 Internal Server error. There is something wrong from our end, check back soon or contact us"
  end
end