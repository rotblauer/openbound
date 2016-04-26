class AddColumnInstitutionTypeToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :Institution_Type, :string
  end
end
