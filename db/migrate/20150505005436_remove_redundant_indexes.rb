class RemoveRedundantIndexes < ActiveRecord::Migration
  def change
  	remove_index :bookmarks, :user_id
  	remove_index :comments, :work_id
  	remove_index :gradients, :user_id
  end
end
