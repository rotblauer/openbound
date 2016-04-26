class RenameCommentColumnToBody < ActiveRecord::Migration
  
  def self.up
    rename_column :comments, :comment, :body
  end

  def self.down
    rename_column :comments, :comment, :body
  end

end
