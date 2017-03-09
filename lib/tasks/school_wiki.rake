# require 'open-uri'
# require 'config/environment'

# open('image.png', 'wb') do |file|
#   file << open('http://example.com/image.png').read
# end

require 'uri'
require 'colorize'
require 'timeout'
require 'wikipedia' # per gem 'wikipedia-client'
# CarrierWave::DownloadError: trying to download a file which is not served over HTTP
namespace :schools do

	desc "Get wikipedia blurb for schools."
	task :wiki_info => :environment do 

		GET_THIS_MANY = 500

		School.where(is_academic: true).where("wikipedia_summary IS ?", nil).order('works_count desc').order('affiliations_count desc').order('Institution_Name asc').first(GET_THIS_MANY).each do |school, index|

			school_name = school.Institution_Name.to_s
			puts ">>>>>>>>>  #{school_name}  (#{index}/#{GET_THIS_MANY})"
			page_exists = false

			begin 
				
				Timeout::timeout(5) {
					page = Wikipedia.find(school_name.gsub('-', ' '))
					if !page.text.nil?
						page_exists = true
						# puts "page.summary => #{page.summary}"
						# puts "page.coordinates => #{page.coordinates.to_json}"
						# puts "page.fullurl => #{page.fullurl}"
						school.wikipedia_summary = page.summary
						school.wikipedia_coords = page.coordinates.to_json if page.coordinates.to_json != 'null' # array, ie [37.87,-122.259,"","earth"]
						school.wikipedia_url = page.fullurl
					end
				}
			# rescue CarrierWave::DownloadError
			#   da_errors.push( case_site+" --------  This url doesn't appear to be valid")
			# rescue CarrierWave::IntegrityError
			#   da_errors.push( case_site+" --------  This url does not appear to point to a valid image")
			# rescue CarrierWave::ProcessingError
			# 	picture_errors.push( case_site+" -------- This image could not be processed by RMagick")
			# rescue Magick::ImageMagickError
			# 	picture_errors.push( case_site+" -------- Rmagick failed for some reason")
			rescue Timeout::Error 
				puts ">>>>>>>>>             timed out".red.on_white
			end 

			if page_exists && school.save
				school.reload
				if !school.wikipedia_summary.blank? # check if summary actually there
					puts "Summary: #{school.wikipedia_summary.truncate_words(25)}".green
					puts "Coords:  #{school.wikipedia_coords}".green
					puts "Url:     #{school.wikipedia_url}".green
					puts "SAVED".green.on_white
				else 
					puts ">>>>>>>>>             FAILED TO SAVE".red.on_yellow
				end
			else 
				puts ">>>>>>>>>             FAILED".red.on_white
			end
		end
	end
end
