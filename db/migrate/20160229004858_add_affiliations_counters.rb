class AddAffiliationsCounters < ActiveRecord::Migration
  def change
  	# rename_column :schools, :users_count, :affiliations_count
  	# add_column :users, :affiliations_count, :integer, null: false, default: 0

  	# User.all.each do |u|
  	# 	u.update_attributes(affiliations_count: u.affiliations.count)
  	# 	puts "Update #{u.name} affiliations count -> #{u.affiliations.count}"
  	# end 
  end
end
