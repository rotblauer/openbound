class AddColumnFaviconToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :favicon, :string
  end
end
