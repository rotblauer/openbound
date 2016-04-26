class AddColumnFileContentHtmlToWorks < ActiveRecord::Migration
  def change
    add_column :works, :file_content_html, :string
  end
end
