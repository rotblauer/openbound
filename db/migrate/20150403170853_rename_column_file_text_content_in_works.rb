class RenameColumnFileTextContentInWorks < ActiveRecord::Migration
  def change
  	rename_column :works, :file_text_content, :file_content_text
  end
end
