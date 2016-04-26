class WebometricUniversity < ActiveRecord::Base
	self.table_name = 'webometric_universities'
	self.primary_key = 'id'

	belongs_to :country, 
	  :foreign_key => 'country_id'

	# has_many :some_other_ideal_models, 
	#   :foreign_key => 'foreign_key_on_this_table', 
	#   :primary_key => 'primary_key_on_other_table'

end