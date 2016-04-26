class AddColumnSwotIsAcademicToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :is_academic, :boolean
  end
end
