# require "carrierwave-docsplit/version"

# If you're not relying on Gemfile entries alone and are requiring "carrierwave" anywhere, ensure you require "fog/rackspace/storage" before it. Ex:
# https://github.com/carrierwaveuploader/carrierwave
require "fog/rackspace/storage"
# require 'fog-aws'
require 'carrierwave'
# require 'docsplit'
unless defined? Docsplit
  begin
    require 'docsplit'
  rescue LoadError
    puts "WARNING: Failed to require docsplit, document processing may fail!"
  end
end
require 'json'
require 'pathname'
require 'fileutils'

module CarrierWave
  module Carsplit
  # Include storage module becuase it can't hurt. It could be slow, though. 
  # include Storage
  # include FileUtils

    class NoModelError < Exception
      def message
        "Text extraction requires a model for the uploader to write results to."
      end
    end

    ### Extract thumb. 
    # def extract_thumb
    #     #self.setup_image_extraction_thumb
    #     out = "/tmp/docsplit"
    #     Docsplit.extract_images self.current_path, :size => %w(200x), :format => :jpg, :pages => %(1), :output => out
    #     thumb_filename = "#{self.file.basename}_1.jpg"
    #     File.delete(current_path)
    #     FileUtils.mv(out+thumb_filename, current_path)
    # end

    def setup_image_extraction_thumb
      # I think self here refers to uploader.
      self.instance_eval do
        # Calls work to set_slug so model.slug is available. 
        # self.model.get_slug_preview # undefined method `model' for DocumentUploader:Class

        # Define output path for docsplit. 
        define_method :output_path_thumb do
          return nil if self.file.nil?
          # Change output to CarrierWave cache and append version size folder 
          ## (automatically created by Docsplit when making more than one size version.)
          # This should expose clean_cache method and avoid permissions issue. 
          # File.expand_path(File.join self.docsplit_cache_dir, "200x") # NoMethodError - undefined method `join' for CarrierWave::Storage::File:Class:
  #       self.cache_dir  
          "#{self.store_dir}/200px"
          # File.expand_path(File.join self.current_path.chomp(self.document.original_filename), "200x")
        end
        # Latch our extraction method into the processing queue.
        process :enact_extraction_thumb
        define_method :enact_extraction_thumb do 
          # Create local cache directory if it doesn't already exist. 
          out = self.output_path_thumb
          FileUtils.mkdir_p out
          # Tell me everything. 
          # puts ">>>>>>>>>> self.type.name = #{self.type.name}" # NoMethodError - undefined method `type' for #<DocumentUploader:0x007ffd01f93318>
          # puts ">>>>>>>>>> self.file.path => #{self.file.path}" # -> /tmp/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.slug}/1437394578-5662-7984/2BruceBender.pdf
          # puts ">>>>>>>>>> self.cache_dir => #{self.cache_dir}" # -> /tmp/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.slug}
          thumb_name = "#{self.file.basename}_1.jpg"
          # Do the splits. 
          Docsplit.extract_images self.file.path, :size => %w(200x), :format => :jpg, :pages => %(1), :output => out
          
          # puts "#{self.model.file_name.chomp(self.file.extension)[0..-2]}_1.jpg" # NoMethodError - undefined method `chomp' for nil:NilClass:
          # thumb_name = "#{self.model.file_name.chomp(self.file.extension)[0..-2]}_1.jpg"

          # puts "#{self.original_filename.chomp(self.file.extension)[0..-2]}_1.jpg" # NoMethodError - private method `original_filename' called for #<DocumentUploader:0x007fafcbd45508>:
          # thumb_name = "#{self.original_filename.chomp(self.file.extension)[0..-2]}_1.jpg"

#          puts ">>>>>>>>>> would-be docsplit filename => #{self.file.basename}_1.jpg" # -> 2BruceBender_1.jpg
          

#          puts "#{out}/#{thumb_name}"
#          new_thumb_path = "#{out}/#{thumb_name}"

          # Cache outputted file to make CarrierWave::Sanitized. 
          # cached_version = self.cache!(new_thumb_path)# CarrierWave::FormNotMultipart - You tried to assign a String or a Pathname to an uploader, for security reasons, this is not allowed.
          # cached_version = self.cache!(new_thumb_path.open)# NoMethodError - private method `open' called for #<String:0x007f96f2e28908>:
          # cached_version = self.cache!(FileUtils.open(new_thumb_path)) # NoMethodError - private method `open' called for FileUtils:Module:
#          cached_version = self.cache!(FileUtils.open(new_thumb_path)) # include FileUtils
#          puts ">>>>>>>>>> cached_version => #{cached_version}"

          # Use CarrierWave's store method to save the file to S3 or local depending on env. 
          # CarrierWave::Storage::Fog 
          # self.retrieve_from_cache!(new_thumb_path)
          # CarrierWave::SanitizedFile = retrieve!
          # By default, store!() uses copy_to(), which operates by copying the file from the cache to the store, then deleting the file from the cache. 
          # self.store!(new_thumb_path) # CarrierWave::FormNotMultipart - You tried to assign a String or a Pathname to an uploader, for security reasons, this is not allowed.
#          self.store!(cached_version) 
          # then delete file. 
         

          # if Rails.env.production?
          #   File.open("#{out}/#{@thumb_name}") do |file|
          #     thumb = self.store!(file)
          #   end
          # end
          
        end

#         # def copy_with_fog
#         #     begin
#         #       # source_container = fog_directoy
#         #       source_container = "#{Rails.root}/public/#{self.store_dir}/200x/#{thumb_name}"
#         #       target_container = fog_public ? 'private_container_name' : 'public_container_name'
              
#         #       fog_api = Fog::Storage.new(fog_credentials)
               
#         #       fog_api.copy_object(source_container, store_dir, target_container, store_dir)
#         #       fog_api.delete_object(source_container, store_dir) 
                
#         #     rescue Fog::Errors::Error
#         #       model.errors.add(mounted_as, 'Error occured while migrating file in storage!'))
#         #       false
#         #     end
#         #   end
#         # end 

      end
    end

    ### Extract preview.
    def extract_preview
        self.setup_image_extraction_preview
    end
    def setup_image_extraction_preview
       self.instance_eval do
        define_method :output_path_preview do
          return nil if self.file.nil?
          File.expand_path(File.join self.docsplit_dir, "700x")
        end
        # Latch our extraction method into the processing queue.
        process :enact_extraction_preview
        define_method :enact_extraction_preview do 
          out = self.output_path_preview
          FileUtils.mkdir_p out
          Docsplit.extract_images self.file.path, :size => %w(700x), :format => :jpg, :pages => %(1), :output => out
        end
      end
    end

    ### Extract thumb and preview.
    def extract_thumb_and_preview
      self.setup_image_extraction_thumb_and_preview
    end
    def setup_image_extraction_thumb_and_preview
      self.instance_eval do 
        define_method :output_path_thumb_and_preview do 
          return nil if self.file.nil?
          File.path(self.docsplit_dir)
        end
        process :enact_extraction_thumb_and_preview
        define_method :enact_extraction_thumb_and_preview do 
          out = self.output_path_thumb_and_preview
          FileUtils.mkdir_p out
          Docsplit.extract_images self.file.path, :size => %w(200x 700x), :format => :jpg, :pages => %(1), :output => out
        end
      end
    end 

    ### Extract full. 
    def extract_full
        self.setup_image_extraction_full
    end
    def setup_image_extraction_full
      self.instance_eval do
        define_method :output_path_full do
          return nil if self.file.nil?
          File.expand_path(File.join self.docsplit_dir, "1000x")
        end
        # Latch our extraction method into the processing queue.
        process :enact_extraction_full
        define_method :enact_extraction_full do 
          out = self.output_path_full
          FileUtils.mkdir_p out
          Docsplit.extract_images self.file.path, :size => %w(1000x), :format => :jpg, :output => out
        end
      end
    end

  end
end


####################################################################################################

# require "carrierwave-docsplit/version"

# require 'carrierwave'
# require 'docsplit'
# require 'json'
# require 'pathname'
# require 'fileutils'

# module CarrierWave
#   module DocsplitIntegration

#     class NoModelError < Exception
#       def message
#         "Text extraction requires a model for the uploader to write results to."
#       end
#     end

#     # Setup the extraction.
#     #
#     #

#     def extract(options = {})
#       if options[:images]
#         self.setup_image_extraction options[:images]
#       end

#       if options[:text]
#         self.setup_text_extraction options[:text]
#       end
#     end

#     def setup_text_extraction(options)
#       self.instance_eval do
#         process :enact_text_extraction

#         define_method :enact_text_extraction do
#           raise NoModelError if @model.nil?

#           out = File.join self.store_dir, self.file.basename
#           FileUtils.mkdir_p out
#           Docsplit.extract_text self.file.path, :ocr => false, :output => out
#           text = File.read Dir.glob(File.join(out, '*.txt')).first

#           @model.send "#{options[:to]}=", text
#         end
#       end
#     end

#     def setup_image_extraction(options)
#        self.instance_eval do

#         define_method :output_path do
#           return nil if self.file.nil?
#           File.expand_path(File.join self.store_dir, self.file.basename)
#         end

#         # Latch our extraction method into the processing queue.
#         process :enact_extraction => options[:sizes]


#         # Define a reader to access the thumbnails stored on disk.
#         #
#         # Returns a hash structured like so.
#         #
#         # {
#         #   '700x700' => ['/uploads/w9/700x/w9_1.png']
#         # }
#         #
#         # This allows for accessing the sizes like this:
#         #
#         # file.thumbs['700x700']

#         define_method options[:to] do
#           path = File.join(self.output_path, '*')

#           dirs_or_files = Dir.glob(path)
#           reduced = {}

#           # Multiple Sizes
#           if dirs_or_files.any? { |entry| entry.match /\d+x\d*/ }

#             Dir.glob(path) do |dirs|
#               if dirs.is_a?(String)
#                 dirs = [] << dirs
#               end

#               dirs.each do |dir|
#                 thumbs = Dir.glob(File.join(dir, '*'))
#                 key = File.basename(dir)
#                 reduced[key] = thumbs
#               end
#             end

#           # Only as single size supplied
#           else
#             options.delete :to
#             size = options[:sizes].values.first
#             reduced[size] = dirs_or_files
#           end

#           reduced
#         end

#         define_method :enact_extraction do |*args|
#           args.flatten!

#           # zip the args back into the hash the user wrote them in.
#           if args.size == 0 || (args.size % 2) > 0
#             raise ArgumentError, "Need an even amount of arguments (Given #{args.size} #{args.size % 2})"
#           end

#           sizes = args.each_slice(2).reduce({}) { |mem, pair| mem.merge({ pair.first => pair.last }) }

#           self.class.class_eval do
#             sizes.keys.each { |size| version size }
#           end

#           out = self.output_path

#           FileUtils.mkdir_p out

#           Docsplit.extract_images self.file.path, :size => sizes.values, :output => out
#         end
#       end
#     end
#   end
# end