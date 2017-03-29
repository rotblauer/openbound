# encoding: utf-8
# require 'carrierwave/processing/mime_types'
require 'carrierwave/processing/rmagick'
class FaviconUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MimeTypes
  # include CarrierWave::MiniMagick

  ## Storage handled in initializers/carrierwave.rb.
  #
  #
    # Choose what kind of storage to use for this uploader:
    # storage :file
    # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  def cache_dir
    '/tmp/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}'
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png gif ico)
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))

    # "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    "/images/fallback/" + [version_name, "school_favicon.png"].compact.join('_')
  end

  # process :get_picture

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  process :save_content_type_and_size_in_model
  process :store_dimensions

  # Create different versions of your uploaded files:
  version :sixty_four_x do
    process :resize_to_limit => [64, 64]
  end

  version :thirty_two_x, from_version: :sixty_four_x do
    process :resize_to_limit => [20, 20]
  end

  version :twelve_x, from_version: :thirty_two_x do
    process :resize_to_limit => [12, 12]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  private

    def store_dimensions
      if file && model
        # model.width, model.height = ::RMagick::Image.open(file.file)[:dimensions]
        # model.width, model.height = ::MiniMagick::Image.open(file.file)[:dimensions]
        img = ::Magick::Image::read(file.file).first
              model.favicon_width = img.columns
              model.favicon_height = img.rows
      end
    end

    def save_content_type_and_size_in_model
      model.favicon_content_type = file.content_type if file.content_type
      model.favicon_file_size = file.size
    end

end
