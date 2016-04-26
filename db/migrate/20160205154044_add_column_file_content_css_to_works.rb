class AddColumnFileContentCssToWorks < ActiveRecord::Migration
  def change
    add_column :works, :file_content_css, :text, :limit => 2.megabyte
  end
end
