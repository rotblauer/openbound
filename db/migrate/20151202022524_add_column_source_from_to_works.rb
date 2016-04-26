class AddColumnSourceFromToWorks < ActiveRecord::Migration
  def change
    add_column :works, :source_from, :string
  end
end
