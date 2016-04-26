class AddColumnsTypeAndYearsToAffiliations < ActiveRecord::Migration
  def change
    add_column :affiliations, :type, :string
    add_column :affiliations, :year, :string
  end
end
