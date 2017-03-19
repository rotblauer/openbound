# require 'carrierwave/processing/rmagick'
class PreviewUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "previews/#{model.class.to_s.underscore}/#{mounted_as}/#{model.user.uuid.to_s}/#{model.slug}"
  end

  def cache_dir
    "#{Rails.root}/tmp/previews/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    "/images/fallback/document/square-circle.png"
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :small do
    # process :convert => 'jpg'
    process :resize_to_limit => [200, 200]
    # process :quality => 70
  end
  version :thumb, from_version: :small do
    # process :convert => 'jpg'
    process :resize_to_limit => [100, 100]
    # process :quality => 70
  end
  version :pinky, from_version: :thumb do
    # process :convert => 'jpg'
    process :resize_to_limit => [50, 50]
    # process :quality => 70
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
