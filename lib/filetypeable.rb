module Filetypeable

	
	def is_extractable?
	  %w( application/excel
	      application/vnd.ms-excel
	      application/x-excel
	      application/x-msexcel
	      application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
	      application/mspowerpoint
	      application/powerpoint
	      application/vnd.ms-powerpoint
	      application/x-mspowerpoint
	      application/vnd.openxmlformats-officedocument.presentationml.presentation
	      application/pdf ).include? self.content_type
	end

	# Decides if the work is doc or docx for the preview at Works#Show (how to display, ie. text vs. image)
	def docordocx?
	  self.content_type == 'application/msword' || self.content_type ==  'application/vnd.openxmlformats-officedocument.wordprocessingml.document' 
	end
	def image?
	  self.content_type.start_with? 'image'
	end
	def pdf?
	  self.content_type == 'application/pdf'
	end
	def plain_text?
	  self.content_type == 'text/plain'
	end
	def type_rtf?
	  self.content_type == 'text/rtf'
	end
	def markdown?
	  self.content_type == ('text/markdown' || 'text/x-markdown') || (!self.file_name.nil? && self.file_name.end_with?('.md'||'.markdown'||'.mdown'||'.mkdn'||'.mkd'||'.mdtxt'||'.mdtext'))
	end
	def latex?
	  %w( application/x-latex
	      application/octet-stream ).include? self.content_type
	end
	def type_html?
	  self.content_type == 'text/html'
	end
	def open_office?
	  %w( application/vnd.oasis.opendocument.text
	      application/vnd.oasis.opendocument.presentation
	      application/vnd.oasis.opendocument.spreadsheet ).include? self.content_type
	end 
	def spreadsheet?
	  %w( application/excel
	      application/vnd.ms-excel
	      application/x-excel
	      application/x-msexcel
	      application/vnd.openxmlformats-officedocument.spreadsheetml.sheet ).include? self.content_type
	end
	def powerpoint?
	  %w( application/mspowerpoint
	      application/powerpoint
	      application/vnd.ms-powerpoint
	      application/x-mspowerpoint
	      application/vnd.openxmlformats-officedocument.presentationml.presentation ).include? self.content_type
	end
	def i_works? 
	  %w( application/x-iwork-keynote-sffkey
	      application/x-iwork-pages-sffpages
	      application/x-iwork-numbers-sffnumbers
	      application/vnd.apple.numbers
	      application/vnd.apple.pages
	      application/vnd.apple.keynote ).include? self.content_type
	end
	def google_file?
	  self.content_type == 'google'
	end
	def from_google_drive?
	  self.source_from == 'google_drive'
	end
	def file_type_supported? 
	  docordocx? ||
	  image? ||
	  pdf? ||
	  plain_text? ||
	  type_rtf? ||
	  markdown? ||
	  type_html? ||
	  spreadsheet? ||
	  powerpoint? || 
	  open_office? ||
	  latex? ||
	  i_works? || 
	  google_file?
	end
	def download_name(string)
		# s = string[/.*(?=\..+$)/]
		r = string.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
		r
	end
end