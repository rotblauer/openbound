class ChangeEncodingForTextColumnsInWorks < ActiveRecord::Migration
  def change
  	change_column :works, :file_content_md, :text, :limit => 10.megabyte
  	change_column :works, :file_content_html, :text, :limit => 10.megabyte
  	change_column :works, :file_content_text, :text, :limit => 10.megabyte
  end
end
