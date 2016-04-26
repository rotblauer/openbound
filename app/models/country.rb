class Country < ActiveRecord::Base
	self.table_name = 'countries'
	self.primary_key = 'id'

	# belongs_to :other_ideal_model, 
	#   :foreign_key => 'foreign_key_on_other_table'

	has_many :linkedinuniversities, 
		:class_name => 'LinkedinUniversity',
	  :foreign_key => 'country_id', 
	  :primary_key => 'id'

	has_many :webometricuniversities, 
		:class_name => 'WebometricUniversity',
	  :foreign_key => 'country_id', 
	  :primary_key => 'id'

end