class AddOneMoreCounterCacheToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :revisions_count, :integer, default: 0
  end
end
