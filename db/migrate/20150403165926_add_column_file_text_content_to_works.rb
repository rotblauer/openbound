class AddColumnFileTextContentToWorks < ActiveRecord::Migration
  def change
    add_column :works, :file_text_content, :text
  end
end
