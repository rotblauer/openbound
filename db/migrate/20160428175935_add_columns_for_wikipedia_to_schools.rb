class AddColumnsForWikipediaToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :wikipedia_summary, :text
    add_column :schools, :wikipedia_coords, :string
    add_column :schools, :wikipedia_url, :string
  end
end
