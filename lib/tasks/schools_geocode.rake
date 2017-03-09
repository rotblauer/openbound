require 'net/https'
require 'uri'
require 'colorize'
require 'timeout'
require 'json'

namespace :schools do
	desc 'get json geocode info from google for schools'
	task :google_geocode => :environment do

		THIS_MANY = 500
		schools = School.where(is_academic: true).where("geocode_json IS ?", nil).order('projects_count desc').order('affiliations_count desc').order('works_count desc').first(THIS_MANY)

		# http://edgeguides.rubyonrails.org/4_1_release_notes.html
		gapi_key = Rails.application.secrets.google_api_key

		base_url = 'https://maps.googleapis.com/maps/api/geocode/json?'
		api_key_parameter = "&key=#{gapi_key}"

		def build_query(school, base_url, api_key_parameter)
			formatted_address_query = 'address='

			formatted_address_query += school.Institution_Address + ", " if !school.Institution_Address.nil?
			formatted_address_query += school.Institution_City + ", " + school.Institution_State

			# replace spaces as per google demo
			formatted_address_query.gsub!(' ', '+')
			query = base_url + formatted_address_query + api_key_parameter
			query
		end

		schools.each do |school|

			if school.geocode_json.nil?

				# if !(school.Institution_Name && school.Institution_City && school.Institution_State)
				# 	puts "There was not address information for #{school.Institution_Name}".red.on_white
				# 	return
				# end
				begin
					query_string = build_query(school, base_url, api_key_parameter)

					uri = URI.parse(query_string)
					http = Net::HTTP.new(uri.host, uri.port)
					http.use_ssl = true
					http.verify_mode = OpenSSL::SSL::VERIFY_NONE

					request = Net::HTTP::Get.new(uri.request_uri)

					response = http.request(request)

					if (response.code.to_i == 200)

						# Confirm affirm response code.
						puts "#{response.code} - #{school.Institution_Name}".white.on_green

						# @param {String}
						# @return {Object}
						objectifiedBod = JSON.parse response.body

						if school.update_attributes(
							geocode_json: response.body.to_s,
							geocode_lat: objectifiedBod['results'][0]['geometry']['location']['lat'].to_f,
							geocode_lng: objectifiedBod['results'][0]['geometry']['location']['lng'].to_f)

							puts ":) #{school.Institution_Name}.".green
							puts "  @ [#{school.geocode_lat}, #{school.geocode_lng}]".green
							# puts "  @@ #{school.geocode_json}".white.on_black

						else
							puts ":( Couldn't save #{school.Institution_Name}".red
						end

					# Else request failed.
					else

						puts "Request failed.".red.on_white
						puts "RESPONSE #{response.code} - #{response.message}".red.on_white
						puts "^~> SCHOOL name: #{school.Institution_Name}".red.on_white

					end

				rescue Exception => e
					puts ":( #{school.Institution_Name}"
					puts "#{e.message} \n #{e.backtrace.inspect}".red.on_white
				end

			# Else we have geocode location data for the school already.
			else
				puts "Already have location data for #{school.Institution_Name}.".green.on_white
				puts "~-> [#{school.geocode_lat}, #{school.geocode_lng}]".green.on_white
			end
		end
	end
end


# This is what a successful response looks like.

# {
#    "results" : [
#       {
#          "address_components" : [
#             {
#                "long_name" : "101",
#                "short_name" : "101",
#                "types" : [ "street_number" ]
#             },
#             {
#                "long_name" : "North Merion Avenue",
#                "short_name" : "N Merion Ave",
#                "types" : [ "route" ]
#             },
#             {
#                "long_name" : "Bryn Mawr",
#                "short_name" : "Bryn Mawr",
#                "types" : [ "locality", "political" ]
#             },
#             {
#                "long_name" : "Lower Merion Township",
#                "short_name" : "Lower Merion Township",
#                "types" : [ "administrative_area_level_3", "political" ]
#             },
#             {
#                "long_name" : "Montgomery County",
#                "short_name" : "Montgomery County",
#                "types" : [ "administrative_area_level_2", "political" ]
#             },
#             {
#                "long_name" : "Pennsylvania",
#                "short_name" : "PA",
#                "types" : [ "administrative_area_level_1", "political" ]
#             },
#             {
#                "long_name" : "United States",
#                "short_name" : "US",
#                "types" : [ "country", "political" ]
#             },
#             {
#                "long_name" : "19010",
#                "short_name" : "19010",
#                "types" : [ "postal_code" ]
#             },
#             {
#                "long_name" : "2859",
#                "short_name" : "2859",
#                "types" : [ "postal_code_suffix" ]
#             }
#          ],
#          "formatted_address" : "101 N Merion Ave, Bryn Mawr, PA 19010, USA",
#          "geometry" : {
#             "location" : {
#                "lat" : 40.0263,
#                "lng" : -75.312867
#             },
#             "location_type" : "ROOFTOP",
#             "viewport" : {
#                "northeast" : {
#                   "lat" : 40.0276489802915,
#                   "lng" : -75.31151801970849
#                },
#                "southwest" : {
#                   "lat" : 40.0249510197085,
#                   "lng" : -75.31421598029151
#                }
#             }
#          },
#          "place_id" : "ChIJYee2Moy_xokRykT-TzJONr8",
#          "types" : [ "street_address" ]
#       }
#    ],
#    "status" : "OK"
# }
