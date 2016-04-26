class AddColumnsDiffTextsToDiffs < ActiveRecord::Migration
  def change
    add_column :diffs, :right_text, :text, :limit => 10.megabyte
    add_column :diffs, :left_text, :text, :limit => 10.megabyte
  end
end
