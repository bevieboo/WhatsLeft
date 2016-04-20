require 'carrierwave'
require 'carrierwave/orm/activerecord'

class ImageUploader < CarrierWave::Uploader::Base
  storage :file
end

class User < ActiveRecord::Base
  has_many :recipes
  has_secure_password
  mount_uploader :img_url, ImageUploader
  validates :password, confirmation: true
  validates :first_name, presence: true
  validates :last_name, presence: true

end
