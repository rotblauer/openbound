class AddColumnDescriptionToWorks < ActiveRecord::Migration
  def change
    add_column :works, :description, :string
  end
end
