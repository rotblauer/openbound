class AddColumnTextToDiffs < ActiveRecord::Migration
  def change
    add_column :diffs, :diff_text, :text, :limit => 10.megabyte
  end
end
