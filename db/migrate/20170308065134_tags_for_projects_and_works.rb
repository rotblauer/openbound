class TagsForProjectsAndWorks < ActiveRecord::Migration
  def change
    # Add tags columns to projects and works.
    add_column :works, :tags, :text, array: true, default: []
    add_column :projects, :tags, :text, array: true, default: []

  end
end
