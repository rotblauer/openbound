class LinkedinUniversity < ActiveRecord::Base
	self.table_name = 'linkedin_universities'
	self.primary_key = 'id'

	belongs_to :country, 
	  :foreign_key => 'country_id'

	# belongs_to :other_ideal_model, 
	#   :foreign_key => 'foreign_key_on_other_table'

	# has_many :some_other_ideal_models, 
	#   :foreign_key => 'foreign_key_on_this_table', 
	#   :primary_key => 'primary_key_on_other_table'

end
