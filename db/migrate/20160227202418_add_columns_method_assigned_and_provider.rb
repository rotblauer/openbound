class AddColumnsMethodAssignedAndProvider < ActiveRecord::Migration
  def change
  	add_column :affiliations, :assignment_method, :string
  	add_column :affiliations, :provider, :string
  end
end
