class AddColumnsLeftAndRightToDiffs < ActiveRecord::Migration
  def change
    add_column :diffs, :left, :text, :limit => 10.megabyte
    add_column :diffs, :right, :text, :limit => 10.megabyte
  end
end
