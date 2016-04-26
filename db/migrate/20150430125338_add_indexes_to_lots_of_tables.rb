class AddIndexesToLotsOfTables < ActiveRecord::Migration
  def change
  	add_index :bookmarks, [:user_id, :work_id], unique: true
  	add_index :comments, [:work_id, :user_id]
  	add_index :gradients, [:user_id, :work_id], unique: true
  	add_index :suggesteds, :work_id
  end
end
