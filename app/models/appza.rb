class Appza < ApplicationRecord
  serialize :requires
  
  after_initialize do |appza|
    appza.requires = [] if appza.requires == nil
  end

  validates :name, presence: true, length: { minimum: 3, maximum: 30 }
  validates :url, presence: true
  validates :callback_url, presence: true
  validates :accept_header, presence: true
  validates :requires, presence: true, length: { minimum: 1, maximum: 4 }
end
