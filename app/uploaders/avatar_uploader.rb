# encoding: utf-8
require 'carrierwave/processing/rmagick'
class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.uuid}"
  end
  def cache_dir
    '/tmp/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.user.uuid}'
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png gif)
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  
    # "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    place = "/images/fallback/" + ["avatar_default", version_name].compact.join('_') + ".png"
    puts "I am looking here for avatar fallback images #{place}"
    return place
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :face do
    process :resize_to_fit => [150, 200]
  end  

  version :hand, from_version: :face do
    # process :resize_to_fill => [100, 100]
    process :resize_to_fit => [100, 100]
  end  

  version :thumb, from_version: :hand do
    # process :resize_to_fill => [22, 22]
    process :resize_to_fit => [22, 22]
  end  

  version :pinky, from_version: :thumb do
    # process :resize_to_fill => [11, 11]
    process :resize_to_fit => [11, 11]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
