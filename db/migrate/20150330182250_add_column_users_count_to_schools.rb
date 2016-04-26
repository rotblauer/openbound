class AddColumnUsersCountToSchools < ActiveRecord::Migration
  def self.up
    add_column :schools, :users_count, :integer, :null => false, :default => 0 
  end

  def self.down
  	remove_column :schools, :users_count, :integer
  end
end
