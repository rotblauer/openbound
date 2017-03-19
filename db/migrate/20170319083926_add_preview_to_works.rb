class AddPreviewToWorks < ActiveRecord::Migration
  def change
    add_column :works, :preview, :string
  end
end
