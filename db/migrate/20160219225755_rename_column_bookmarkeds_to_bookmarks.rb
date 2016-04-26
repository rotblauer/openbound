class RenameColumnBookmarkedsToBookmarks < ActiveRecord::Migration
  def change
  	rename_column :projects, :bookmarked_count, :bookmarks_count
  	remove_column :works, :bookmarked_count
  end
end
