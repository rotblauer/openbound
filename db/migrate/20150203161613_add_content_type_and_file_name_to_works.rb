class AddContentTypeAndFileNameToWorks < ActiveRecord::Migration
  def change
    add_column :works, :content_type, :string
    add_column :works, :file_size, :integer
  end
end
