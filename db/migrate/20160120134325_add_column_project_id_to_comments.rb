class AddColumnProjectIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :project_id, :integer, null: false
  end
end
