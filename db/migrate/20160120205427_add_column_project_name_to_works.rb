class AddColumnProjectNameToWorks < ActiveRecord::Migration
  def change
    add_column :works, :project_name, :string
  end
end
