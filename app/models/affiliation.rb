require 'json'

class Affiliation < ActiveRecord::Base

	# t.belongs_to :user, index: true
	# t.belongs_to :school, index: true
	# t.boolean :is_primary, null: false, default: true
	# t.boolean :is_assignment, null: false, default: true
	# t.boolean :is_preference, null: false, default: false
	# t.boolean :is_active, null: false, default: true
	# t.string :concentration
	# t.boolean :graduated
	# t.boolean :is_fallback
	# t.string :assignment_method <-- <email|oauth|arbitrary> ** LET'S DROP THIS SUCKER. REDUNDANT TO PROVIDER. **
	# t.string :provider <-- <facebook|>
	# t.string :type
	# t.string :year

  belongs_to :user
  belongs_to :school

  counter_culture :user
  counter_culture :school

  validates :user_id, presence: true
  validates :school_id, presence: true

  serialize :concentration

  after_create :assign_primary

  def assign_primary
  	# TODO: how? 
  end

  def assign_as_primary
  	self.update_attributes(is_primary: true)
  end

	# Accepts a facebook linked_account.
	# Returns a hash for affiliation.
	 ## --> RETURNS AN ARRAY.
	def self.parse_facebook_education(user, facebook)

			return_array = []

			# Parse the raw json response from the provider. 
			obj = JSON.parse facebook.oauth_raw_info_json

			puts "Parsing facebook education array objects -> #{obj}"

			# Check to see if we got user_education_history. 
			# This is an array of educational experiences.
			if obj['education']

				education_history = obj['education']
				# for each item in the array
				# TODO which array element is primary? first, last? where :college?
				education_history.each do |ed|

					# Facebook user_education_history api response. 
					# https://developers.facebook.com/docs/graph-api/reference/education-experience/
					# ------------------------------------------------------------------------------
					# classes: list<page>
					# concentration: list<experience>, ie ["Mathematics", "German"]
					# degree: page
					# school: page
					# type: string, ie "College"
					# with: list<user>
					# year: page, ie "2011" <-- year this person graduated
					# ------------------------------------------------------------------------------
					# + school_id: integer, ie 411
					hashy = {}

					# Set school_id. 
					# ------------------------------------------------------------------------------
					# Get school name.
					school_name = ed['school']['name']
					# Attempt to match by name. 

					# First, attempt to match by exact name.

					school_matched_by_exact_name = School.find_by(Institution_Name: school_name)
					
					if school_matched_by_exact_name
						s_id = school_matched_by_exact_name.id
						fallbacker = false

					# Else no match by name, try to match by email. 
					else 
						school_matched_by_email = match_email(user.email) # returns spy u if no match
						
						# If match by email is NOT a fallback, use it. 
						if school_matched_by_email[1] = false 
							s_id = school_matched_by_email[0].id
							fallbacker = false
							
						# If matched by email is fallback, create the school! Holy shit!
						else
							s = School.create!(Institution_Name: school_name, 
								Institution_Type: ed['type'], 
								is_academic: true,
								provider: 'facebook',
								provider_id: ed['school']['id'])
							s_id = s.id
							fallbacker = false
							# school_matched_by_fuzzy_name = match_fuzzy_name(school_name) 
							# s_id = school_matched_by_fuzzy_name.id
							# fallbacker = false
						end
					end 
					hashy[:school_id] = s_id
					hashy[:is_fallback] = fallbacker
					# ------------------------------------------------------------------------------

					# Set type. 
					hashy[:institution_type] = ed['type'] if ed['type']

					# Set year graduated. 
					hashy[:year] = ed['year']['name'] if ed['year']

					# Set concentration(s) as json array. 
					concentrations = []
					concentration_list = ed['concentration']
					if concentration_list
						concentration_list.each do |c|
							concentrations.push(c['name'])
						end
					end
					hashy[:concentration] = concentrations.to_json

					# Set provider = facebook. 
					hashy[:provider] = 'facebook'

					# Finally, set user id.
					hashy[:user_id] = user.id

					# Push hashy (one education history element)
					return_array.push(hashy)

				end # end for each education in education_history arry
			return return_array
		
		# Else there was no accessible education history. 
		else 
			return return_array
		end # end if education_history
	end

	def self.aff_by_email(user)
		school_email_matched = match_email(user.email)
		s_id = school_email_matched[0].id
		s_is_fallback = school_email_matched[1]
		affable = [{
			user_id: user.id,
			school_id: s_id, # This should succeed even if there is no email. 
			is_fallback: s_is_fallback,
			provider: 'email'
		}]
		affable # array of objects
	end


	############################################
	## Handles on user#create and linked_account#create.
	############################################
	
	# Receives user and a linked_account (which can be nil). 
	# @affable is an array of affiliable hashes. 
	# 	
	def self.handle(user, linked_account)	

		# If there is a linked account.
		if !linked_account.nil?

			# Differentiate providers. 
			case linked_account.provider
			when 'facebook' 

				# Returns an array of creatable objects or false. 
				array_hash = parse_facebook_education(user, linked_account)
				if !array_hash.empty?
					affable = array_hash # here's the damn culprit. the array_hash is an array of hashes. we need to pick one. 
				else 
					affable = aff_by_email(user)
				end
			end
		
		# Else there was no linked account. 
		else 
			affable = aff_by_email(user)

		end

		affable.each do |aff_hash|
			# Add affiliation only if there isn't one already. 
			# Priority of affiliation is determined in User model. 
			add_affiliation(aff_hash) if find_by(user_id: user.id, school_id: aff_hash[:school_id]).nil?			
		end
	end


	############################################
	## Create. 
	############################################

	# Recieves hash, appends user_id, creates Affiliation between User and School. 
	def self.add_affiliation(affable)
		
		if create!(affable)
			puts "Cool. Affiliation saved."
		else 
			puts "Affable shit."
		end
	end


	############################################
	## Matchers. 
	############################################

	def self.match_fuzzy_name(school_name)
		if school_name.nil?
			return nil
		else 
			# This return always one school, no matter how far fetched, e.g. 'Asher College' for 'asdf'
			match = School.find_by_fuzzy_Institution_Name(school_name, :limit => 1).first
			return match
		end
	end

	# Returns [best match <School>, is_fallback <bool>]
  def self.match_email(email)
  	
  	# User.school_best_match
	  if !email.nil? 
	    # original email that has already been validated to contain "...@...[.edu]" <-- see VALID_EMAIL_REGEX above in validations
	    user_email = email
	    # splits user's email and keeps everything after "@"
	    user_email_domain = user_email.split("@").last
	    # n number of schools where their email domain matches our inferred email domain (distilled from Institution_Web_Address for all schools)
	    matching_schools = School.where(school_domain_slice: [user_email_domain]).all

	    # if there is more than one matching school according to our email domain comparison, choose the first "Actually"-accredited row
	    if matching_schools.count > 1
	      return [matching_schools.where(Accreditation_Date_Type: "Actual").first, false]

	    # if there is no matching school by email domain comparison use Swot. 
	    elsif matching_schools.count == 0

	      # tl;dr ----> we see if Swot has something we don't. 
	      # Check if Swot thinks their email is academic (it's validation could have instead passed the ".edu" test) 
	      # ==> We choose the potential for our own false positive over Swot's false negative. 
	      if Swot::is_academic? user_email
	        # matching swot's school name against our database
	        swot_school_name = Swot::school_name user_email
	        swot_school_name_match = School.where("Institution_Name LIKE :name", :name => "#{swot_school_name}").first
	        # if we get a match, we assume that our school_domain_slice is incorrect or incomplete and trust swot's suggestion, but use our own associated school's data
	        # nb: THIS IS WHERE A FACT TABLE WOULD BE USEFUL. --> we could add another school_domain_slice for the same school 
	        if swot_school_name_match.present?
	          return [swot_school_name_match, false]
	        # if we don't get a match for swot's academic intuition against our own data, we create a brand new school using swot's name, the user's email_domain, stamp it swot-approved
	        # , and make it the user's school. population =1.
	        else
	          new_school = School.create!(Institution_Name: swot_school_name, school_domain_slice: user_email_domain, is_academic: true, affiliations_count: 1)
	          return [new_school, false]
	        end
	      # else neither we nor swot can match a school to this mystery .edu or .uk.ac email. 
	      # hardcoded highway to hell: Spy University.
	      else
	        return [School.friendly.find('spy-university'), true]
	      end

	    # otherwise, we have a found a unique match in our db against their email domain and our school_domain_slice and we take it and run. 
	    else # (matching_schools.count == 1)
	      return [matching_schools.first, false] # assuages concerns over any array-relation feeling that may be lurking
	    end

	  # Else there is no email provided. 
	  else 
	    return [School.friendly.find('spy-university'), true]
	  end
	end


end
