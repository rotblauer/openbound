# encoding: utf-8

# https://github.com/danielfarrell/carrierwave_docsplit/blob/master/lib/carrierwave_docsplit.rb
# UPDATES TO THIS FILE REQUIRE SERVER RESTART.

unless defined? Docsplit
  begin
    require 'docsplit'
  rescue LoadError
    puts "WARNING: Failed to require docsplit, document processing may fail!"
  end
end
require 'fileutils'
# module CarrierWave
#   module DocsplitCarry
module Split
    # VERSION = 0.1

    # Checks file type by extension. 
    # def pdf?
    #   current_path[-3,3] == 'pdf'
    # end

    # # Picks the pdf document by choosing the file with pdf extension. 
    # def pdf
    #   current_path[0..current_path.rindex('.')] + 'pdf'
    # end

    # def length
    #   ::Docsplit.extract_length(current_path)
    # end

    # def create_pdf
    #   ::Docsplit.extract_pdf(current_path, output: output_path) unless pdf?
    #   self
    # end
    def split_extract
      out = "tmp/docsplit/200x"
      Docsplit.extract_images self.current_path, :size => %w{200x}, :format => :jpg, :pages => %w{1}, output: out
      move_to = File.join (current)
      File.delete(self.current_path)
      FileUtils.mv out + "200x", self.current_path + "/200x"
      # FileUtils.mv out + "200x", self.current_path + "700x"
      # FileUtils.mv out + "200x", self.current_path + "1000x"
    end

    # Extract first page versions.
    # The version sizes *because there are multiple* get put into respectively named folders. 
    # Works for development. 
    def extract_first_page_images
      #######
      # Docsplit.extract_images(document.file.file, :size => %w{200x 700x 1000x}, :format => :jpg, :pages => %w{1}, output: output_path)
      Docsplit.extract_images(file.path, :size => %w{200x 700x 1000x}, :format => :jpg, :pages => %w{1}, output: "public/#{self.docsplit_dir}" )
      
      # def store_path(for_file=filename)
      #   # File.join([store_dir, full_filename(for_file)].compact)
      #   "#{self.model.class.to_s.underscore}" + "/" + "#{mounted_as}" + "/" + "#{self.model.user.uuid.to_s}" + "/" + "#{self.model.slug}" + "/" + "#{(version_name || :original).to_s}" + "_" + "#{self.file.basename}" + ".jpg"
      # end
      # if Rails.env.production?
      #   document.store!(new_file="#{output_path}/200x/#{document.model.file_name.chomp(document.model.document.file.extension)[0..-2]}_1.jpg}")
      #   document.store!(new_file="#{output_path}/700x/#{document.model.file_name.chomp(document.model.document.file.extension)[0..-2]}_1.jpg}")
      #   document.store!(new_file="#{output_path}/1000x/#{document.model.file_name.chomp(document.model.document.file.extension)[0..-2]}_1.jpg}")
      # end
      # Docsplit.extract_images(document.file.file, :size => %w{200x 700x 1000x}, :format => :jpg, :pages => %w{1}, output: "/tmp/uploads/docsplit/#{model.class.to_s.underscore}/#{model.slug}")


      # ::Docsplit.extract_images(self.pdf, :size => %w{200x 700x 1000x}, :format => :jpg, :pages => %w{1}, output: output_path)
      # if Rails.env.production?
      #   # Rename file folders. 
      #   FileUtils.mv local_output_path + "160x", s3_output_path + "160x"
      #   FileUtils.mv local_output_path + "700x", s3_output_path + "700x"
      #   FileUtils.mv local_output_path + "1000x", s3_output_path + "1000x"
      # end
      
      true
      # self
    end
    # # Extract full images. 
    # def extract_full_images
    #   ::Docsplit.extract_images(self.pdf, :size => %w{1000x}, :format => :jpg, output: output_path)
    #   #FileUtils.mv output_path + "1000x", output_path + "normal"
    #   self
    # end

    # For production. 
    # First, we need to save the uploaded file temporarily. 



    # Then we process the uploaded file on ec2.
    # Then we save the processed file to s3. 



#     https://openbound-library.s3.amazonaws.com/uploads/work/document/e371cb7e-cd35-44bc-a0e2-2edd7a2a0895/a473733a-b1ac-4b29-ae2d-b1e5b78a17fa/2BruceBender.pdf
# Docsplit.extract_images("https:#{Work.first.document.url}", :size => %w{200x 700x 1000x}, :format => :jpg, :pages => %w{1}, output: "#{Work.first.document.url.chomp(Work.first.document.model.file_name)}")
# Docsplit.extract_images("https://openbound-library.s3.amazonaws.com/uploads/work/document/e371cb7e-cd35-44bc-a0e2-2edd7a2a0895/a473733a-b1ac-4b29-ae2d-b1e5b78a17fa/2BruceBender.pdf", :size => %w{200x 700x 1000x}, :format => :jpg, :pages => %w{1}, output: "#{Work.first.document.url.chomp(Work.first.document.model.file_name)}")
    
    # def extract_text
    #   ::Docsplit.extract_text(self.pdf, :ocr => true, output: output_path)
    #   self
    # end

    # def input_path
    #   if !Rails.env.production
    #     return document.file.file
    #   else
    #     return "#{Work.first.document.url}"
    #   end
    # end

    # # private

    # # Differentiates between local and S3 storage. 
    def output_path
      # uploads/work/document/e371cb7e-cd35-44bc-a0e2-2edd7a2a0895/ff9f2fb6-29a7-4123-b4ef-e1f288ba6b89
      puts ">>>>>>>>> Process output_path: public/#{document.store_dir}" 
      return "public/#{document.store_dir}" 
    end
    # def s3_output_path
    #   # https://openbound-library.s3.amazonaws.com/uploads/work/document/e371cb7e-cd35-44bc-a0e2-2edd7a2a0895/ff9f2fb6-29a7-4123-b4ef-e1f288ba6b89/2BruceBender.pdf 
    #   return "#{document.url.chomp(document.model.file_name)}"
    # end

  # end
end