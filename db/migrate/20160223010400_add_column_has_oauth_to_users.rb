class AddColumnHasOauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_oauth, :boolean, default: false, null: false
    User.all.each do |user|
    	puts "Updating #{user.name} :has_oauth => false"
    	user.update_attribute(:has_oauth, false)
    end
  end
end
