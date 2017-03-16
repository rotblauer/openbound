class ChangeTagsColumnsToString < ActiveRecord::Migration
  def change
    change_column :projects, :tags, :string, array: true, default: '{}'
    change_column :works, :tags, :string, array: true, default: '{}'
  end
end
