class AddColumnSupermanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :superman, :boolean, :null => false, :default => false
  end
end
