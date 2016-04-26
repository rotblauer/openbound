class AddColumnAuthorNameToWorks < ActiveRecord::Migration
  def change
    add_column :works, :author_name, :string
  end
end
