class ChangeNullablenessForCounterCulturables < ActiveRecord::Migration
  def change
  	change_column_null :projects, :comments_count, false
  	change_column_null :projects, :revisions_count, false
  	change_column_null :projects, :diffs_count, false
  	change_column_null :schools, :works_count, false
  	change_column_null :schools, :projects_count, false
  	change_column_null :users, :projects_count, false
  	change_column_null :users, :comments_count, false
  	change_column_null :works, :revisions_count, false
  	change_column_null :works, :comments_count, false
  end
end
