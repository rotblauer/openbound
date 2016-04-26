class AddColumnGradientAverageRgbToWorks < ActiveRecord::Migration
  def change
    add_column :works, :gradient_average_rgb, :integer, :null => false, :default => 0
  end
end
