class ChangeColumnsTagsDefaultBackToArray < ActiveRecord::Migration
  def change
    change_column_default :projects, :tags, []
    change_column_default :works, :tags, []
  end
end
