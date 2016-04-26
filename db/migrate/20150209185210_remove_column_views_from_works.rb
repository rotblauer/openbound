class RemoveColumnViewsFromWorks < ActiveRecord::Migration
  def change
    remove_column :works, :views, :integer
  end
end
