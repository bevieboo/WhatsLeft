require 'carrierwave'
require 'carrierwave/orm/activerecord'

class ImageUploader < CarrierWave::Uploader::Base
  storage :file
end

class User < ActiveRecord::Base
  has_many :recipes
  has_secure_password
  mount_uploader :img_url, ImageUploader
end
