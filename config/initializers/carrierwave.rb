require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

# require 'fog'
require 'carrierwave/processing/rmagick'
if Rails.env.production?
  CarrierWave.configure do |config|
    # This was turned off and worked fine.
    # config.fog_provider = 'fog/aws'                        # required
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID_I'],                        # required # Isaac's
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY_I'],                        # required
      region:                'us-west-1'                  # optional, defaults to 'us-east-1'
    }
    config.storage :fog
    config.fog_directory  = 'openbound-library'                          # required
    config.fog_public     = true                                        # optional, defaults to true
    config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
  end
end

if Rails.env.development?
	CarrierWave.configure do |config|
    config.storage :file
    # Turns noisy errors on for development. Don't do much.
		config.ignore_integrity_errors = false
		config.ignore_processing_errors = false
		config.ignore_download_errors = false
	end
end

# Turns :file storage on and processing off for testes.
if Rails.env.test?
	CarrierWave.configure do |config|
		config.storage = :file
		config.enable_processing = false
	end
end
