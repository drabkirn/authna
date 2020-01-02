class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :omniauthable

  # OTP Token
  has_one_time_password
  enum otp_module: { disabled: 0, enabled: 1 }, _prefix: true
  attr_accessor :otp_code_token

  # Username
  USERNAME_REGEX = /\A[a-z0-9\_]+\z/i

  validates :username, uniqueness: { case_sensitive: true }, presence: true, length: { minimum: 3, maximum: 10 }, format: { with: USERNAME_REGEX, multiline: true }

  before_save :downcase_username

  def self.authenticate(email, password, username = "")
    if username.present?
      user = User.find_for_authentication(username: username)
    else
      user = User.find_for_authentication(email: email)
    end
    user&.valid_password?(password) ? user : nil
  end

  def self.from_omniauth(auth)
    return where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.nickname[0..9]
    end
  end

  private
    def downcase_username
      self.username = self.username.downcase
    end
end
