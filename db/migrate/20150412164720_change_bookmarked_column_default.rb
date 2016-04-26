class ChangeBookmarkedColumnDefault < ActiveRecord::Migration
  def change
  	change_column_default :bookmarks, :bookmarked, false
  end
end
