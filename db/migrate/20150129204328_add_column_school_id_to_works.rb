class AddColumnSchoolIdToWorks < ActiveRecord::Migration
  def change
  	add_column :works, :school_id, :integer
  end
end
