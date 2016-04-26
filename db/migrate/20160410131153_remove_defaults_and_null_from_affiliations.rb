class RemoveDefaultsAndNullFromAffiliations < ActiveRecord::Migration
  
  # The is_primary attr was a good idea that I never actually implemented. 
  # Instead I use User.school_primary to pick the 'school of best fit'.
  # In order to pass sovereignty back to the actualy members it seems best to 
  # institute this attr that will more easily allow members to pick for themselves 
  # (along with some user_helper methods) after we assign a best guess default. 

  def change
  	change_column_default :affiliations, :is_primary, false

  	Affiliation.all.each do |a|
  		a.update_attributes(is_primary: false)
  	end
  end
end
