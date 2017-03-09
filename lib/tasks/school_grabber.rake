# require 'open-uri'
# require 'config/environment'

# open('image.png', 'wb') do |file|
#   file << open('http://example.com/image.png').read
# end

require 'uri'
require 'colorize'
require 'timeout'
# CarrierWave::DownloadError: trying to download a file which is not served over HTTP
namespace :schools do

	desc "snag all the schools' favicons for local storage"
	task :favicons => :environment do

		# school_pick = ENV["SCHOOLS"] || 'all'
		# puts "school_pick => #{school_pick}"
		# puts "#{ENV['SCHOOLS']}"

		# Rails.logger.info Time.now
		puts Time.now
		# Rails.logger.info "Grabbing favicons... "
		puts ">>>>>>>>>  Grabbing favicons... "

		# School.where(is_academic: true).all.each do |school|
		da_errors = []
		sans_valid_url = []
		picture_errors = []
		timeout_errors = []
		failed_to_save = []
		existing = []
		results = Hash.new

		# if school_pick == 'all'

			#
			# School.order('works_count desc').order('users_count desc').order('Institution_Name desc').where(is_academic: true).first(10).each do |school|
			# School.where(is_academic: true).all.sample(500).each do |school|
			# School.where(is_academic: true).where("favicon IS ?", nil).order('Institution_Name asc').all.each do |school|
			School.where(is_academic: true).where("favicon IS ?", nil).order('works_count desc').order('users_count desc').order('Institution_Name asc').first(200).each do |school, index|
			# School.order('works_count desc').order('users_count desc').order('Institution_Name desc').first(10).each do |school|

				name = school.Institution_Name.to_s
				puts ">>>>>>>>>  #{name}  (#{index}/200)"

				# Skip process if school already has a favicon.
				if school.favicon.blank? && school.Institution_Web_Address.present?

					# Set up URL to download from.
					#
					#
					## Add http and https to beginning of address if neither are present.
					unless (school.Institution_Web_Address[/\Ahttp:\/\//]  || school.Institution_Web_Address[/\Ahttps:\/\//])
					  site_base_http = "http://#{school.Institution_Web_Address}"
					  site_base_https = "https://#{school.Institution_Web_Address}"
					  site_base_original = nil

					  ## strip trailing /'s and add assumed favicon path
					  favicon_site_http = site_base_http.sub(/(\/)+$/,'')+"/favicon.ico"
					  favicon_site_https = site_base_https.sub(/(\/)+$/,'')+"/favicon.ico"
					  try_prepended = true
					end
					## If http(s) is present, keep the original instead.
					if school.Institution_Web_Address[/\Ahttp:\/\//]  || school.Institution_Web_Address[/\Ahttps:\/\//]
						site_base_http = nil
						site_base_https = nil
						site_base_original = school.Institution_Web_Address

						## strip trailing /s and add assumed favicon path
						favicon_site_original = site_base_original.sub(/(\/)+$/,'')+"/favicon.ico"
						try_prepended = false
					end


					# Try original if original.

					if try_prepended == false
						valid = false

						begin
							puts ">>>>>>>>>  ---------> trying #{favicon_site_original}"
							case_site = favicon_site_original
							# check if case_site is valid url
							Timeout::timeout(5) {
								if case_site =~ /\A#{URI::regexp(['http', 'https'])}\z/
									# then set remote_url
									# this also may fail
									school.remote_favicon_url = case_site
									valid = true
								else
									sans_valid_url.push(school.Institution_Name+" @ "+case_site)
								end
							}
						rescue CarrierWave::DownloadError
						  da_errors.push( case_site+" --------  This url doesn't appear to be valid")
						rescue CarrierWave::IntegrityError
						  da_errors.push( case_site+" --------  This url does not appear to point to a valid image")
						rescue CarrierWave::ProcessingError
							picture_errors.push( case_site+" -------- This image could not be processed by RMagick")
						rescue Magick::ImageMagickError
							picture_errors.push( case_site+" -------- Rmagick failed for some reason")
						rescue Timeout::Error
							puts ">>>>>>>>>             timed out".red.on_white

						end

						if valid && school.save
							school.reload
							if !school.favicon.blank? # check if it's actually there
								puts ">>>>>>>>>             SAVED".green.on_white
								results[name] = true
							else
								puts ">>>>>>>>>             FAILED TO SAVE".red.on_yellow
								failed_to_save.push(name)
							end
						else
							puts ">>>>>>>>>             FAILED".red.on_white
							results[name] = false
						end


					# If original doesn't exist,
					## try prepended http and https
					else
						valid = false
						http_saved = false

						begin
							case_site = favicon_site_http
							puts ">>>>>>>>>  ---------> trying #{case_site}"
							# check if case_site is valid url
							Timeout::timeout(5) {
								if case_site =~ /\A#{URI::regexp(['http'])}\z/
									# then set remote_url
									# this also may fail
									school.remote_favicon_url = case_site
									valid = true
								else
									sans_valid_url.push(school.Institution_Name+" @ "+case_site)
								end
							}
						rescue CarrierWave::DownloadError
						  da_errors.push( case_site+" --------  This url doesn't appear to be valid")
						rescue CarrierWave::IntegrityError
						  da_errors.push( case_site+" --------  This url does not appear to point to a valid image")
						rescue CarrierWave::ProcessingError
							picture_errors.push( case_site+" -------- This image could not be processed by RMagick")
						rescue Magick::ImageMagickError
							picture_errors.push( case_site+" -------- Rmagick failed for some reason")
						rescue Timeout::Error
							puts ">>>>>>>>>             timed out".red.on_white
						end

						if valid && school.save
							school.reload
							if !school.favicon.blank? # check if it's actually there
								puts ">>>>>>>>>             SAVED".green.on_white
								results[name] = true
								http_saved = true
							else
								puts ">>>>>>>>>             FAILED TO SAVE".red.on_yellow
								failed_to_save.push(name)
							end
						else
							puts ">>>>>>>>>             FAILED".red.on_white
							results[name] = false
						end


						unless http_saved

							begin
								case_site = favicon_site_https
								puts ">>>>>>>>>  ---------> trying #{case_site}"
								# check if case_site is valid url
								Timeout::timeout(5) {
									if case_site =~ /\A#{URI::regexp(['https'])}\z/
										# then set remote_url
										# this also may fail
										school.remote_favicon_url = case_site
										valid = true
									else
										sans_valid_url.push(school.Institution_Name+" @ "+case_site)
									end
								}
							rescue CarrierWave::DownloadError
							  da_errors.push( case_site+" --------  This url doesn't appear to be valid")
							rescue CarrierWave::IntegrityError
							  da_errors.push( case_site+" --------  This url does not appear to point to a valid image")
							rescue CarrierWave::ProcessingError
								picture_errors.push( case_site+" -------- This image could not be processed by RMagick")
							rescue Magick::ImageMagickError
								picture_errors.push( case_site+" -------- Rmagick failed for some reason")
							rescue Timeout::Error
								puts ">>>>>>>>>             timed out".red.on_white
							end

							if valid && school.save
								school.reload
								if !school.favicon.blank? # check if it's actually there
									puts ">>>>>>>>>             SAVED".green.on_white
									results[name] = true
								else
									puts ">>>>>>>>>             FAILED TO SAVE".red.on_yellow
									failed_to_save.push(name)
								end
							else
								puts ">>>>>>>>>             FAILED".red.on_white
								results[name] = false
							end

						end

					end # End if tries.

				else
					if !school.favicon.blank?
						puts '>>>>>>>>>  ---------> EXISTS'.yellow.on_white
						existing.push(name)
					elsif !school.Institution_Web_Address.present?
						puts '>>>>>>>>>  ---------> **No web address available.**'.red.on_white
					end
				end # End if favicon_blank.

			end # end Schools query



		puts "Finished rake. #{Time.now}"

		successes = results.select {|k,v| v == true}
		failures = results.select {|k,v| v == false}
		puts "> #{successes.length} SAVED / #{existing.length} EXISTING / #{failures.length} FAILED".white.on_black
		# Show errors.
		if !sans_valid_url.empty?
			puts "> Schools without a valid url: ".red.on_yellow
			puts sans_valid_url.join("\n")
		end
		if !da_errors.blank?
			puts "> CarrierWave::Errors: ".red.on_yellow
			puts da_errors.join("\n")
		end
		if !picture_errors.empty?
			puts "> CarrierWave::Rmagick errors: ".red.on_yellow
			puts picture_errors.join("\n")
		end
		if !timeout_errors.empty?
			puts "> Timeout::timeout(5) errors: ".red.on_yellow
			puts timeout_errors.join("\n")
		end
		if !failed_to_save.empty?
			puts "> Failed to save: ".red.on_yellow
			puts failed_to_save.join("\n")
		end
		# Show results.
		# h = { "a" => 100, "b" => 200, "c" => 300 }
		# h.select {|k,v| k > "a"}  #=> {"b" => 200, "c" => 300}
		# h.select {|k,v| v < 200}  #=> {"a" => 100}

		## key = school name, value = saved(->true) or failed(->false)
		puts ">>>>>>>>>>>>>>>>>> SAVED <<<<<<<<<<<<<<<<<<<<".white.on_green
			puts successes.keys.join("\n").green.on_white
		puts ">>>>>>>>>>>>>>>>>> FAILED <<<<<<<<<<<<<<<<<<<<".white.on_red
			puts failures.keys.join("\n").red.on_white
		puts ">>>>>>>>>>>>>>>>>> EXISTING <<<<<<<<<<<<<<<<<<<<".white.on_black
			puts existing.join("\n").green.on_black
	end

end

	# ############################################################
	# url =~ /\A#{URI::regexp(['http', 'https'])}\z/
	# ############################################################
	# valid = false
	# begin
	#   par = params[:image].except(:remote_upload_url)
	#   @image = Image.new(par)
	#   # this may fail:
	#   @image.remote_upload_url = params[:image][:remote_upload_url]
	#   valid = true
	# rescue CarrierWave::DownloadError
	#   da_errors.add( favicon_site+" --------  This url doesn't appear to be valid")
	# rescue CarrierWave::IntegrityError
	#   da_errors.add( favicon_site+" --------  This url does not appear to point to a valid image")
	# end

	# # validate and save if no exceptions were thrown above
	# if valid && @image.save
	#   redirect_to(images_configure_path)
	# else
	#  render :action => 'new'
	# end
	############################################################


	# school.remote_favicon_url = 'www.google.com/s2/favicons?domain='+school.Institution_Web_Address




	# school.remote_favicon_url = 'www.google.com/s2/favicons?domain=harvard.edu/favicon.png'
	# school.save!

  # file = open('http://www.google.com/s2/favicons?domain='+'#{school.Institution_Web_Address}').read
  # school.update_attribute(favicon: file)

  # school.update_attribute(:favicon, open('http://www.google.com/s2/favicons?domain=www.harvard.edu').read)

  # school.favicon = URI.parse('http://www.google.com/s2/favicons?domain=#{school.Institution_Web_Address}')

  # open('favicon.png', 'wb') do |file|
  #   file << open('http://www.google.com/s2/favicons?domain=www.harvard.edu/favicon.png').read
  #   school.update_attribute(:favicon, file)
  # end

	# school.remote_favicon_url = 'https://pbs.twimg.com/profile_images/586137164188004352/wTK4hjbl.jpg'
