class AddColumnBookmarksCountToWorks < ActiveRecord::Migration
  def change
    add_column :works, :bookmarked_count, :integer, :null => false, :default => 0
  end
end
