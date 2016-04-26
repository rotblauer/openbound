class AddColumnProjectIdToBookmarks < ActiveRecord::Migration
  def change
    add_column :bookmarks, :project_id, :integer
  end
end
