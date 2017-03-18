# coding: utf-8
############################################
## A one-stop-shop for converting between file and string types.
############################################

# require 'assets/wdiff.rb'
# require 'html/pipeline'
require 'redcarpet'
require 'redcarpet/render_strip'
require 'pandoc-ruby'
require 'filetypeable.rb'

# Input: Work instance
# Returns true if updates successfully, else returns error.
module ConverterMachine
	include Filetypeable


	############################################
	## Specs.
	############################################

	# Set up Recarpet.
	class Standard
		## Options for interpreting html -> md.
		OPTIONS = {
			  filter_html:     true, # Do not allow any user-inputted HTML in the output.
			  with_toc_data: true, # Add HTML anchors to each header in the output HTML, to allow linking to each section.
			  hard_wrap:       true,
			  link_attributes: { rel: 'nofollow', target: "_blank" },
			  space_after_headers: true,
			  fenced_code_blocks: true
			}


		## Options for interpreting md -> html.
		EXTENTIONS = {
			  autolink:           true,
			  disable_indented_code_blocks: true,
			  space_after_headers: true,
			  superscript:        true,
			  footnotes: true,
			  quote: true,
			  strikethrough: true,
			  highlight: true
			}

		def Standard.renderer
			Redcarpet::Render::HTML.new(OPTIONS) #options
		end
		def Standard.markdowner
			Redcarpet::Markdown.new(Standard.renderer, EXTENTIONS)
		end
		def Standard.renderer_no_images
			Redcarpet::Render::HTML.new(OPTIONS.merge(no_images: true)) #options
		end
		def Standard.markdowner_no_images
			Redcarpet::Markdown.new(Standard.renderer_no_images, EXTENTIONS)
		end

		def Standard.stripper
			Redcarpet::Markdown.new(Redcarpet::Render::StripDown, :space_after_headers => true)
		end
	end



	############################################
	## Public methods
	############################################

	def ConverterMachine.get_work_content(work)
		# All work should have all da words.
		erfsck = ''
		erfsck << "No html content for work id: #{work.id}" unless work.file_content_html
		erfsck << "No markdown content for work id: #{work.id}" unless work.file_content_md
		erfsck << "No plain text content for work id: #{work.id}" unless work.file_content_text
		r = {
			html: work.file_content_html,
			markdown: work.file_content_md,
			plain_text: work.file_content_text
		}
		# puts erfsck
		return r
	end

	# Decode: "&trade;" => "™"
	# Scrub: If the string is invalid byte sequence then replace invalid bytes with given replacement character, else returns self. If block is given, replace invalid bytes with returned value of the block.
	def ConverterMachine.decode_and_scrub(string)
		decoded = HTMLEntities.new.decode string
		decoded.scrub!
		decoded
	end

	def ConverterMachine.html_markdown(work)
		# Use ReverseMarkdown for html -> md.
		# Pass through unknown tags (that means just leave em be).
		md_content = ReverseMarkdown.convert(ConverterMachine.get_work_content(work)[:html], unknown_tags: :pass_through)

    # Decode all html entities and scrub to avoid encoding errors from mysql.
    html_decoded = decode_and_scrub md_content
    html_decoded
	end

	def ConverterMachine.html_text(work)
		# take only the text from only the body
		doc = Nokogiri::HTML(ConverterMachine.get_work_content(work)[:html])
		body = doc.at_xpath("//body")
		body_html = body.to_html
		redoc = Nokogiri::HTML(body_html)
		clean_body = redoc.xpath("//text()").to_s
		fresh_and_clean = decode_and_scrub clean_body
		fresh_and_clean
	end

	def ConverterMachine.clean_html(work)
		doc = Nokogiri::HTML(ConverterMachine.get_work_content(work)[:html])

		## CSS
		# .children means we don't get the parent <style> element
		style = doc.at_xpath("//style")
		style_html = style.to_html

		## BODY
		body = doc.at_xpath("//body").children
		body_html = body.to_html

		return {
			css: style_html,
			html: body_html
		}
	end

	def ConverterMachine.markdown_html(work)
			md = ConverterMachine.get_work_content(work)[:markdown]
			md_to_html = Standard.markdowner.render(md)
			html_final = decode_and_scrub md_to_html
			html_final
	end

	def ConverterMachine.markdown_text(work)
			md = ConverterMachine.get_work_content(work)[:markdown]
			plain = Standard.stripper.render(md)
			plain
	end

	def ConverterMachine.text_markdown
		# unimplemented because too simple or no good way
	end

	def ConverterMachine.text_html
		# unimplemented because too simple or no good way
	end


	# ----------- Downloader ------------ #

	# http://stackoverflow.com/questions/8662250/how-do-i-create-a-temp-file-and-write-to-it-then-allow-users-to-download-it

	def as_file(type) # Not namespaced because Work can just use it straight up.

	  puts ":::::::::::::::::::::WORK.RB receiving :as_file(type) as => #{type}"
	  # output = [self.name]
	  if type == 'markdown'
	    output = self.file_content_md
	    # output.join("\n")

	  elsif type == 'plain'
	    #output = self.file_content_text

	    # :s is :stand_alone doc w/ required headers
	    output = PandocRuby.convert(self.file_content_md, :from => :markdown, :to => :plain)

	  elsif type == 'open_office'
	    # use pandoc to convert md (or html?) to open office
	    output = PandocRuby.convert(self.file_content_md, :s, {:f => :markdown, :to => :odt})

	  elsif type == 'microsoft_word'
	    output = PandocRuby.convert(self.file_content_md, :s, {:f => :markdown, :to => :docx})

	  elsif type == 'pdf'
	  	original_name = "#{self.name}"
	  	basename = original_name[/.*(?=\..+$)/]
	  	output = PandocRuby.convert(self.file_content_md, :s, {:f => :markdown, :o => 'thing.pdf'})

	  end
	  return output
	end



end
