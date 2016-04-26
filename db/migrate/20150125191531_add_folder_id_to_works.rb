class AddFolderIdToWorks < ActiveRecord::Migration
  def change
  	add_column :works, :folder_id, :integer
  end
end
