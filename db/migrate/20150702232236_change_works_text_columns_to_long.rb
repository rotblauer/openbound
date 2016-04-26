class ChangeWorksTextColumnsToLong < ActiveRecord::Migration
  def change
  	if Rails.env.production?
	  	change_column :works, :file_content_md, :binary, :limit => 10.megabyte
	  	change_column :works, :file_content_html, :binary, :limit => 10.megabyte
	  	change_column :works, :file_content_text, :binary, :limit => 10.megabyte
	  end
  end
end
