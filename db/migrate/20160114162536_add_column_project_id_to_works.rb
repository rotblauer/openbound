class AddColumnProjectIdToWorks < ActiveRecord::Migration
  def change
    add_reference :works, :project, index: true
    add_foreign_key :works, :projects
  end
end
