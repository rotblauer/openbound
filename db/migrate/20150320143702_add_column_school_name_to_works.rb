class AddColumnSchoolNameToWorks < ActiveRecord::Migration
  def change
    add_column :works, :school_name, :string
  end
end
