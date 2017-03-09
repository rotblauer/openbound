require 'nokogiri'
require 'open-uri'
require 'colorize'

namespace :schools do 
	desc 'grab logo for specified school and save it'
	task :wiki_logo => :environment do 


		# TODO: 
		# => select scoped schools
		# => convert school name to wikipedia url format	
		# => handle error
		# 
		ERRORS = {}
		THIS_MANY = 500

		SCHOOLS = School.where(is_academic: true).where(logo: nil).order('affiliations_count desc').order('projects_count desc').order('works_count desc').first(THIS_MANY)

		# 'University of Minnesota - Duluth' -> 'https://en.wikipedia.org/wiki/University_of_Minnesota_Duluth'
		def wikiSchoolUrl(school_name)
			base_wiki_url = 'https://en.wikipedia.org/wiki/'
			name = school_name.gsub('- ', '') # remove dashes
			name = name.gsub(' ', '_') # replace spaces with underscore
			r = base_wiki_url + name
			r
		end

		# The img sources from Wikipedia don't have the required https: prefix. 
		def appendHTTPS(partialUrl)
			'https:' + partialUrl
		end

		def findLogoUrl(page)
			html = Nokogiri.HTML(open(page))
			src = html.css('.infobox img')[0]['src']
			src 
		end


		def scrapeLogo(school)
			

			begin 

				school_name = school.Institution_Name
				wiki_url = wikiSchoolUrl(school_name)

				# We could break this up into small chunks for easier error parsing. #TODO. 
				image_url = appendHTTPS(findLogoUrl(wiki_url))

				puts "school_name # => #{school_name}".green.on_white
				puts "wiki_url    # => #{wiki_url}"
				puts "image_url   # => #{image_url}"
				puts "---> attempting to save image as logo..."

				school.remote_logo_url = image_url

			rescue CarrierWave::DownloadError
			  ERRORS[school_name] = "This url doesn't appear to be valid"
			rescue CarrierWave::IntegrityError
			  ERRORS[school_name] = "This url does not appear to point to a valid image"
			rescue CarrierWave::ProcessingError
				ERRORS[school_name] = "This image could not be processed by RMagick"
			rescue Magick::ImageMagickError
				ERRORS[school_name] = "Rmagick failed for some reason"
			rescue NoMethodError => e
				ERRORS[school_name] = "#{e}" # probably because wiki page doesn't have an image in the infobox
			rescue OpenURI::HTTPError => e 
				ERRORS[school_name] = e # probably school has no wikipedia page
			rescue Timeout::Error 
				puts ">>>>>>>>>             timed out".red.on_white
			end 

			if school.save 
				school.reload
				if !school.logo.blank?
					puts "				SAVED #{school_name}".white.on_green
				else 
					puts "				FAILED TO SAVE #{school_name}".red.on_white
					puts "				ERROR =>       #{ERRORS[school_name]}".red.on_white # print associated error
				end
			else 
					puts "				FAILED  #{school_name}".red.on_white
					puts "				FAILED  #{ERRORS[school_name]}".red.on_white # print associated error
			end
		end

		SCHOOLS.each do |school|
			scrapeLogo(school) if school.logo.blank?
			puts "Already have logo for #{school.Institution_Name} - skipping." if !school.logo.blank?
		end

		if ERRORS.any?
			ERRORS.each do |key, val|
				puts "#{key}:#{val}".red.on_white
			end
		end 

		# -----------------------------------------------------------
		# # http://stackoverflow.com/questions/8956249/image-scraping-in-ruby
		# PAGE = 'https://en.wikipedia.org/wiki/Harvard_University'
	

		# html = Nokogiri.HTML(open(PAGE))

		# # src  = html.at('.profilePic img')['src']

		# src = html.css('.infobox img')[0]['src']
		# # file_path = somewhere['src']

		# File.open("foo.png", "wb") do |f|
		#   f.write(open('https:' + src).read)
		# end


	end
end