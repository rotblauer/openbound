class RemoveUnnecessaryColumnFromSchools < ActiveRecord::Migration  
  def change
		remove_column :schools, :Campus_ID, :string
		remove_column :schools, :Campus_Name, :string
		remove_column :schools, :Campus_Address, :string
		remove_column :schools, :Campus_City, :string
		remove_column :schools, :Campus_State, :string
		remove_column :schools, :Campus_Zip, :string
		remove_column :schools, :Campus_IPEDS_UnitID, :string
  end
end


### Fuck. Oh, OK. 