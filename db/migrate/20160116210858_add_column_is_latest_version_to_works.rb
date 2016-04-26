class AddColumnIsLatestVersionToWorks < ActiveRecord::Migration
  def change
    add_column :works, :is_latest_version, :boolean
  end
end
