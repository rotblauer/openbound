class RemoveColumnAssignmentMethodFromAffiliations < ActiveRecord::Migration
  def change
  	remove_column :affiliations, :assignment_method
  end
end
