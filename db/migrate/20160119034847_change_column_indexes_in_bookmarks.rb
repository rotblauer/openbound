class ChangeColumnIndexesInBookmarks < ActiveRecord::Migration
  def change

  	# remove_references :bookmarks, :users
  	
  	# remove_index :bookmarks, name: :index_bookmarks_on_work_id
  	# remove_index :bookmarks, name: :index_bookmarks_on_user_id_and_work_id
  
  	# remove_column :bookmarks, :work_id

  	add_index :bookmarks, :project_id, using: 'btree'
  	add_index :bookmarks, [:project_id, :user_id], using: 'btree'
  end
end
