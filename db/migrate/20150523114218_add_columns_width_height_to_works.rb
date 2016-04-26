class AddColumnsWidthHeightToWorks < ActiveRecord::Migration
  def change
    add_column :works, :width, :integer
    add_column :works, :height, :integer
  end
end
