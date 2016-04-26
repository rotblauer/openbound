class AddGradientAverageToWorks < ActiveRecord::Migration
  def change
    add_column :works, :gradient_average, :float
    add_column :works, :gradient_count, :int, :null => false, :default => 0
  end
end
