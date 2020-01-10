class Appza < ApplicationRecord
  belongs_to :user
  
  serialize :requires
  
  after_initialize do |appza|
    appza.requires = [] if appza.requires == nil
    appza.secret = SecureRandom.hex(15) if appza.secret.empty?
  end

  validates :name, presence: true, length: { minimum: 3, maximum: 30 }
  validates :url, presence: true
  validates :callback_url, presence: true
  validates :accept_header, presence: true
  validates :requires, presence: true, length: { minimum: 1, maximum: 4 }
  validates :secret, presence: true, length: { is: 30 }, uniqueness: { case_sensitive: true }
  validates :user_id, presence: true

  validate :check_for_valid_url, :check_for_valid_callback_url
  validate :user_must_be_admin

  private

  def user_must_be_admin
    if !self.user.admin?
      errors.add(:user_id, Message.must_be_admin)
    end
  end
  
  def check_for_valid_url
    uri = URI.parse(url) rescue false
    check_url(uri, "url") if uri
  end

  def check_for_valid_callback_url
    uri = URI.parse(callback_url) rescue false
    check_url(uri, "callback_url") if uri
  end

  def check_url(uri, symbol_name)
    whitelisted_hosts = ["192.168.225.128", "localhost"]
    if uri.host.nil?
      errors.add(symbol_name.to_sym, Message.valid_hosts_url)
    elsif whitelisted_hosts.include?(uri.host)
      return
    elsif !uri.is_a?(URI::HTTPS)
      errors.add(symbol_name.to_sym, Message.valid_https_url)
    end
  end
end
