class AddColumnWorksCountToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :works_count, :integer, default: 0
  end
end
