class AddColumnNewEmailConfirmedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :new_email_confirmed, :boolean, default: false
    change_column :users, :new_email, :string, unique: true
  end
end
