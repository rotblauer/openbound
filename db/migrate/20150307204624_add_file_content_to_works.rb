class AddFileContentToWorks < ActiveRecord::Migration
  def change
    add_column :works, :file_content, :string
  end
end
