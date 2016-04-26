class RenameColumnTypeInAffiliations < ActiveRecord::Migration
  def change
  	rename_column :affiliations, :type, :institution_type
  end
end
