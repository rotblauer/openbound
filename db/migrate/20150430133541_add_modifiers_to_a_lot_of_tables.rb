class AddModifiersToALotOfTables < ActiveRecord::Migration
  def change
  	# Unlike change_column (and change_column_default), change_column_null is reversible.
  	change_column_null :bookmarks, :user_id, false
  	change_column_null :bookmarks, :work_id, false

  	change_column_null :comments, :user_id, false
  	change_column_null :comments, :work_id, false
  	change_column_null :comments, :body, false

  	change_column_null :gradients, :user_id, false
  	change_column_null :gradients, :work_id, false
  	change_column_null :gradients, :grad, false

  	change_column_null :users, :email, false
  	change_column_null :users, :slug, false

  	change_column_null :works, :user_id, false
  	change_column_null :works, :slug, false
  end
end
