class AddColumnViewsToWorks < ActiveRecord::Migration
  def change
    add_column :works, :views, :integer
  end
end
