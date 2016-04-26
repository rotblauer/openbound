class AddColumnAnonymouseToWorks < ActiveRecord::Migration
  def change
    add_column :works, :anonymouse, :boolean, :null => false, :default => false
  end
end
