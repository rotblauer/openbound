class AddColumnCreatedAsOauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :created_as_oauth, :boolean, default: false, null: false
    # User.all.each do |user|
    	# user.update_attributes(created_as_oauth: false) # none have this at time of migration
    # end
  end
end
