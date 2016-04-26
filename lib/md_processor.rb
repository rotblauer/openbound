###################################
## This file is not use. It was an attempt to 'outsource' the doc -> markdown processing, 
## which might not be a bad idea in the long haul. 
###################################


# require 'fileutils'
# require 'word-to-markdown'
# module CarrierWave
# 	module MDProcessor

# 		module ClassMethods
#       def process_md
#         process :process_md
#       end
#     end

# 		def process_md
# 			# Find current file

			
# 			markdown = WordToMarkdown.new(file.path).to_s
# 			newfile = File.new
# 			newfile.basename = file.basename
# 			newfile.ext = "md"
# 			file.open("#{newfile}", 'w') { |f| f.write("#{markdown}") }
			


# 			# directory = File.dirname( current_path )
# 			# tmpfile = File.join(directory, "tmpfile")

# 			# FileUtils.mv(directory, tmpfile)

# 			# markdown = ::WordToMarkdown.new(tmpfile).to_s
# 			# File.open("#{file.basename}.md", 'w') { |f| f.write("#{markdown}") }
# 			# File.close

# 			# File.delete(tmpfile)

# 			# Move file to new temp location (creates a new version)
# 			# 


# 			#### This sucker makes a markdown version but it puts it in the root directory. BOOM!
# 			# def markdowning
# 			#   markdown = WordToMarkdown.new(file.path).to_s
# 			#   File.open("#{file.basename}.md", 'w') {|f| f.write("#{markdown}") }

# 			# end

# 		end
# 	end
# end
