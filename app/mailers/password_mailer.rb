class PasswordMailer < ApplicationMailer
  default from: ENV["devise_mailer_from_address"]

  def forget_email(user)
    @user = user
    mail(to: @user.email, subject: 'Authna: Reset Password')
  end
end
