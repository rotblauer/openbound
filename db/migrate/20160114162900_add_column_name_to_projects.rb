class AddColumnNameToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :name, :string
    add_column :projects, :slug, :string
    add_column :projects, :recent_work_id, :integer
    add_column :projects, :anonymouse, :boolean
    add_column :projects, :school_name, :string
    add_column :projects, :impressions_count, :integer, :default => 0, :null => false
  	add_column :projects, :bookmarked_count, :integer, :default => 0, :null => false
  	add_column :projects, :description, :string
  end
end
