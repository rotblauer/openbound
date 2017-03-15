class ChangeTagsColumnsToObjsAsDefault < ActiveRecord::Migration
  def change
    change_column_default :works, :tags, '{}'
    change_column_default :projects, :tags, '{}'
  end
end
