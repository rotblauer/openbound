class ChangeColumnTextStorageDataTypesInWorks < ActiveRecord::Migration
  def change
  	change_column :works, :file_content_md, :longtext
  	change_column :works, :file_content_html, :longtext
  	change_column :works, :file_content_text, :longtext
  end
end
