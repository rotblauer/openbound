class AddColumnWorksCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :works_count, :integer, :null => false, :default => 0
  end
end
