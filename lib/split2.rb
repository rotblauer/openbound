# encoding: utf-8

unless defined? Docsplit
  begin
    require 'docsplit'
  rescue LoadError
    puts "WARNING: Failed to require docsplit, document processing may fail!"
  end
end
require 'fileutils'
require 'fog/rackspace/storage'

module CarrierWave

  module Docsplit
    VERSION = 0.1

    def pdf?
      current_path[-3,3] == 'pdf'
    end

    def pdf
      current_path[0..current_path.rindex('.')] + 'pdf'
    end

    def length
      ::Docsplit.extract_length(current_path)
    end

    def create_pdf
      ::Docsplit.extract_pdf(current_path, output: output_path) unless pdf?
      self
    end

    def extract_images_split2
      Rails.logger.debug "#{current_path}"
      # Parent of processing file. 

      ::Docsplit.extract_images(current_path, :size => %w{200x 700x}, :pages => %(1), :format => :jpg, output: output_path)


      # Get parent dir of current_path
      # parent_path = File.expand_path("..", current_path)
      # Delete original version. 
      # File.delete(current_path)
      # FileUtils.cp_r output_path, parent_path + "/200x"
      # FileUtils.mv output_path + "700x", parent_path + "/700x"
      # FileUtils.mv output_path + "1000x", output_path + "large"
      self
    end

    def extract_text
      ::Docsplit.extract_text(self.pdf, :ocr => true, output: output_path)
      self
    end

    private

    def output_path
      # "public/uploads/docsplit/"
      "#{store_dir}"
    end
  end
end