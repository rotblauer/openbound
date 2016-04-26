class AddFileNameToWorks < ActiveRecord::Migration
  def change
    add_column :works, :file_name, :string
  end
end
