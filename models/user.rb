require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'fog'

# CarrierWave.configure do |config|
#   config.fog_credentials = {
#     # Configuration for Amazon S3
#     :provider              => 'AWS',
#     :aws_access_key_id     => ENV['S3_KEY'],
#     :aws_secret_access_key => ENV['S3_SECRET'],
#     :region                => 'ap-southeast-2',
#     :host   => 's3-ap-southeast-2.amazonaws.com'
#   }
#
#   config.storage = :fog
#   config.fog_directory    = ENV['S3_BUCKET']
#
#   # config.cache_dir = "#{Rails.root}/tmp/uploads"                  # To let CarrierWave work on heroku
# end

class ImageUploader < CarrierWave::Uploader::Base
  storage :file

  # def store_dir
  #   "../public/"
  # end

end

class User < ActiveRecord::Base
  has_many :recipes
  has_secure_password
  mount_uploader :img_url, ImageUploader
  validates :password, confirmation: true
  validates :first_name, presence: true
  validates :last_name, presence: true

end
