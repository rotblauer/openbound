class AddColumnHasPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_password, :boolean, null: false, default: true
    User.all.each do |user|
    	user.update_attributes(has_password: true)
    end
  end
end
