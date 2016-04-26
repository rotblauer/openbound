class FixFileContentName < ActiveRecord::Migration

  def self.up
    rename_column :works, :file_content, :file_content_md
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end

end
