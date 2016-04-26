class ChangeColumnBookmarkedInBookmarks < ActiveRecord::Migration
  def change
  	change_column_default :bookmarks, :bookmarked, true
  end
end
