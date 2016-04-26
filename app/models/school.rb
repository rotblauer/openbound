class School < ActiveRecord::Base
  extend FriendlyId
  friendly_id :Institution_Name, use: :slugged
  fuzzily_searchable :Institution_Name
  # init fuzzily
  # MyStuff.bulk_update_fuzzy_name
	
	has_many :affiliations, dependent: :destroy
	has_many :users, through: :affiliations
	
	has_many :works
	has_many :projects

	mount_uploader :favicon, FaviconUploader
	mount_uploader :logo, LogoUploader

	searchable do 
		# Search in. 
		text :Institution_Name, :boost => 5.0
		text :Institution_State
		text :Institution_Zip
		# Order and with by. 
		string :Institution_Name
		string :Institution_City
		string :Accreditation_Date_Type
		integer :works_count
		integer :affiliations_count
		boolean :is_academic
	end

	# Set default scopes. 
	# default_scope { order(works_count: :desc) }
	# default_scope { order(affiliations_count: :desc) }
	# default_scope { order(updated_at: :desc) }

	############################################
	## Can use with 
	#```
	#$ rails console
	#$ schools = School.all
	#$ schools.each do |s|
	#$ s.update_works_count
	#$ end
	#```
	###########################################	
	###########################################		
	## After touch updates for users & works counts
	###########################################	

	# Update counts on self.
	# def update_works_count
	# 	self.update_attribute(:works_count, self.works.count)
	# end
	# def update_users_count
	# 	self.update_attribute(:users_count, self.users.count)
	# end

	# http://stackoverflow.com/questions/14124212/remove-duplicate-records-based-on-multiple-columns
	def self.dedupe
	  # find all models and group them on keys which should be common
	  grouped = all.group_by{|model| [model.Institution_Name,model.Institution_City,model.Institution_State,model.Institution_Web_Address] }
	  grouped.values.each do |duplicates|
	    # the first one we want to keep right?
	    first_one = duplicates.shift # or pop for last one
	    # if there are any more left, they are duplicates
	    
	    # so delete all of them
			duplicates.each{|double| double.destroy} # duplicates can now be destroyed
			# duplicates.each{|double| Rails.logger.info(double.Institution_Name)} # duplicates can now be destroyed
	  end
	end

	############################################
	## stuff for exporting/importing the archived CSV from the gov't
	############################################
	# def self.to_csv(options = {})
	# 	CSV.generate(options) do |csv|
	# 		csv << column_names
	# 		all.each do |school|
	# 			csv << school.attributes.values_at(*column_names)
	# 		end
	# 	end
	# end

	# def self.import(file)
	# 	CSV.foreach(file.path, headers: true) do |row|
	# 		School.create! row.to_hash
	# 	end
	# end

end
