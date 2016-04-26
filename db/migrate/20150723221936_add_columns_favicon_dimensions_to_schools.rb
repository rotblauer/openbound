class AddColumnsFaviconDimensionsToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :favicon_width, :integer
    add_column :schools, :favicon_height, :integer
    add_column :schools, :favicon_content_type, :string
    add_column :schools, :favicon_file_size, :integer
  end
end
