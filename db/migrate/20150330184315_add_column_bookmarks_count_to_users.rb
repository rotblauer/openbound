class AddColumnBookmarksCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bookmarks_count, :integer, :null => false, :default => 0
  end
end
