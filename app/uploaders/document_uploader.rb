require 'word-to-markdown'
require 'html/pipeline'
require 'yomu'
require 'pandoc-ruby'
require 'escape_utils'
# require 'carrierwave/processing/mime_types'
require 'carrierwave/processing/rmagick'
# require 'RMagick'
class DocumentUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MimeTypes
  include CarrierWave::RMagick

  ## This depends on every work *always* being connected to an existing user.
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.user.uuid.to_s}/#{model.slug}"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}" # MUST BE DOUBLE QUOTED STRINGS
    # http://stackoverflow.com/questions/8854725/rails-3-getting-errnoeacces-permission-denied-when-uploading-files-on-product
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    WHITE_ARM
  end

  # Allowed file types.
  WHITE_ARM =
    %w(
      jpg jpeg gif png bmp
      txt html rtf md
      doc docx
      pdf
      ppt xls pptx xlsx
      csv
      odt ods odp
      tex
      pages numbers key
      )
      # x-latex

  # Actively supported file types for previewing.
  STRONG_ARM =
    %w(
      jpg jpeg gif png bmp
      txt html rtf md
      doc docx
      pdf
      ppt xls pptx xlsx
      odt ods odp
      tex
      pages numbers key
      )

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    # "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    "/images/fallback/document/square-circle.png"
    # puts "I am looking here for avatar fallback images #{place}"
    # return place
  end



  # Saves content type and file size as model attributes.
  # process :set_content_type # this method comes with the included CarrierWave::MimeTypes module
  process :save_content_type_and_size_in_model
  process :save_source_in_model
  process :store_dimensions, :if => :document_image?



  ############################################
  ##   These methods are designed to extract as simply as possible the file contents into their
  ##   nearest possible attribute type, ie Markdown, HTML, or plain text.
  ##   They only save extracted text into a single column.
  ##   Filling out the rest of the columns is delegated through a Work.after_create callback
  ##   to Work.init_textuals.
  ############################################


  # DOC DOCX
  # If it's a MSWord document, save the markdowned contents of the file as a model attribute (text field).
  ## .doc(x) -[w2m]-> md -[HTML::Pipline::MarkdownFilter]-> html
  process :set_file_contents_md_and_html, :if => :document_msword_document?
  def set_file_contents_md_and_html
    # creates markdown-formatted string from the msword doc text and data
    # NOTE: pandoc can also do this, though there are very slight differences,
    # like the pandoc adds \# to escape it's headers, while w2m doesn't
    # > pandoc -s example30.docx -t markdown -o example35.md
    md = WordToMarkdown.new(file.path).to_s

    # set file content to utf8 version
    md_utf8 = md.force_encoding("UTF-8")
    model.file_content_md = md_utf8
  end
  handle_asynchronously :set_file_contents_md_and_html

  # TXT
  process :read_file_contents_to_text_attribute, :if => :document_plain_text_document?
  def read_file_contents_to_text_attribute
    text = File.read(file.path)

    # set file content to utf8 version
    text_utf8 = text.force_encoding("UTF-8")
    model.file_content_text = text_utf8
  end
  handle_asynchronously :read_file_contents_to_text_attribute

  # MD
  process :store_markdown_text, :if => :document_markdown_document?
  def store_markdown_text
    md_content = File.read(file.path)
    md_content_utf8 = md_content.force_encoding("UTF-8")
    model.file_content_md = md_content_utf8
  end

  # HTML
  process :read_file_contents_to_html_attribute, :if => :document_html_document?

  ## .html -[ReverseMarkdown.convert]-> md
  def read_file_contents_to_html_attribute
    html_content = File.read(file.path)
    html_content_utf8 = html_content.force_encoding("UTF-8")
    model.file_content_html = html_content_utf8
  end

  # TEX
  process :convert_latex_to_markdown, :if => :document_latex_document?
  def convert_latex_to_markdown
    # https://github.com/alphabetum/pandoc-ruby
    # Pandoc can also be set to take a file path as the first argument. For security reasons, this is disabled by default, but it can be enabled and used as follows
    PandocRuby.allow_file_paths = true

    md_content = PandocRuby.convert(file.path, :from => :latex, :to => :markdown)
    md_content_utf8 = md_content.force_encoding("UTF-8")
    model.file_content_md = md_content_utf8
  end
  handle_asynchronously :convert_latex_to_markdown

  # JPEG JPG GIF PNG
  # Creates a thumb , preview, and fitted (works/show) versions of any image, also keeping the original.
  ## Fitted for works/show.
  version :fitted, :if => :document_image? do
    # process :resize_to_limit => [600, 600]
    process :resize_to_limit => [600, 600]
  end
  ## Preview for _modal.
  version :preview, from_version: :fitted, :if => :document_image? do
    # process :resize_to_limit => [360, 360]
    process :resize_to_limit => [360, 360]
  end
  ## Thumb for _work.
  version :thumb, from_version: :preview, :if => :document_image? do
    # process :resize_to_limit => [160, 200]
    process :resize_to_limit => [160, 200]
  end

  # PDF
  # Take only the first page.
  def cover
    begin

      manipulate! do |frame, index|
        # frame if index.zero?
        frame if (index == 0)
      end

    rescue ::Magick::ImageMagickError => e
      raise CarrierWave::ProcessingError, I18n.translate(:"errors.messages.rmagick_processing_error", :e => e, :default => I18n.translate(:"errors.messages.rmagick_processing_error", :e => e, :locale => :en))

    end
  end

  # PNG_thumb
  version :png_thumb, :if => :document_pdf_document? do
    process :cover
    process :convert => :png
    process :resize_to_limit => [200, 300]
    process :set_content_type_png
    def full_filename (for_file = model.document.file)
      super.chomp(File.extname(super)) + '.png'
    end
  end

  # PNG_preview
  version :png_preview, :if => :document_pdf_document? do
    process :cover
    process :convert => :png
    process :resize_to_limit => [600, 1000]
    process :set_content_type_png
    def full_filename (for_file = model.document.file)
      super.chomp(File.extname(super)) + '.png'
    end
  end

  # http://stackoverflow.com/questions/19546637/carrierwave-setting-content-type-incorrectly
  def set_content_type_png(*args)
    Rails.logger.debug "#{file.content_type}"
    self.file.instance_variable_set(:@content_type, "image/png")
  end

  private

    def store_dimensions
      if file && model
        img = ::Magick::Image::read(file.file).first
              model.width = img.columns
              model.height = img.rows
      end
    end

    def save_content_type_and_size_in_model
      model.content_type = file.content_type if file.content_type
      model.file_size = file.size
    end

    def save_source_in_model
      model.source_from = "file_upload"
    end

  protected

      def document_open_office?(new_file) # [odt, odp, ods]
        if new_file
          %w( application/vnd.oasis.opendocument.text
              application/vnd.oasis.opendocument.presentation
              application/vnd.oasis.opendocument.spreadsheet ).include? new_file.content_type
        end
      end

      def document_markdown_document?(new_file) # [text/markdown || text/x-markdown]
        if new_file
          new_file.content_type.include? 'markdown'
        end
      end

      def document_pdf_document?(new_file) # [application/pdf]
        if new_file
          r = %w( application/pdf ).include? new_file.content_type
          puts "
PROCESSING A PDF....
                #{r}
                #{new_file.content_type}
"
          return r
          # new_file.content_type.include? 'application/pdf'
        end
      end

      def document_plain_text_document?(new_file) # [text/plain]
        if new_file
          new_file.content_type == 'text/plain'
        end
      end

      def document_rtf_document?(new_file) # [text/rtf]
        if new_file
          new_file.content_type == 'text/rtf'
        end
      end

      def document_html_document?(new_file) # [text/html]
        if new_file
          new_file.content_type == 'text/html'
        end
      end

      def document_msword_document?(new_file)
        if new_file
          (new_file.content_type == 'application/msword') || (new_file.content_type == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
        end
      end

      # .xls, .xlsx, .ppt, .pptx
      def document_spreadsheet_or_powerpoint?(new_file)
        if new_file
          %w( application/mspowerpoint
              application/powerpoint
              application/vnd.ms-powerpoint
              application/x-mspowerpoint
              application/vnd.openxmlformats-officedocument.presentationml.presentation
              application/excel
              application/vnd.ms-excel
              application/x-excel
              application/x-msexcel
              application/vnd.openxmlformats-officedocument.spreadsheetml.sheet ).include? new_file.content_type
        end
      end

      def document_image?(new_file) # [image/jpeg] (<-- == .jpg also) [image/png] [image/gif]
        if new_file
          %w( image/jpeg
              image/png
              image/gif ).include? new_file.content_type
          # new_file.content_type.include? 'image'
        end
      end

      def document_latex_document?(new_file)
        if new_file
          %w( application/x-latex
            ).include? new_file.content_type
        end
      end

      def document_i_works?(new_file)
        if new_file
          %w( application/x-iwork-keynote-sffkey
              application/x-iwork-pages-sffpages
              application/x-iwork-numbers-sffnumbers
              application/vnd.apple.numbers
              application/vnd.apple.pages
              application/vnd.apple.keynote ).include? new_file.content_type
        end
      end

end
