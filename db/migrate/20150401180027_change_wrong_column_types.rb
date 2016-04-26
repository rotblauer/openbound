class ChangeWrongColumnTypes < ActiveRecord::Migration
  def change
  	# Comments. 
  	change_column :comments, :user_id, :integer
  	change_column :comments, :work_id, :integer
  	remove_column :comments, :parent_id, :integer
  	add_index :comments, :user_id
  	add_index :comments, :work_id

  	# Schools.
  	change_column :schools, :Institution_ID, :integer

  	# Works.
  	change_column :works, :file_content_md, :text
  	change_column :works, :file_content_html, :text
  	remove_column :works, :folder_id, :integer
  end
end
