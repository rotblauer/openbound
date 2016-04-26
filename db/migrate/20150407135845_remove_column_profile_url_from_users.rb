class RemoveColumnProfileUrlFromUsers < ActiveRecord::Migration
  def self.up
  	remove_column :users, :profile_url, :string
  end
  def self.down
  	add_column :users, :profile_url, :string
  end
end
