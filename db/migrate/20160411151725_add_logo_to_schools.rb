class AddLogoToSchools < ActiveRecord::Migration
  def change
  	add_column :schools, :logo, :string
  	add_column :schools, :remote_logo_url, :string
  	add_column :schools, :logo_width, :integer
  	add_column :schools, :logo_height, :integer
  	add_column :schools, :logo_content_type, :string
  	add_column :schools, :logo_file_size, :integer

  	# t.string   "favicon",                  limit: 255
  	# t.string   "remote_favicon_url",       limit: 255
  	# t.integer  "favicon_width",            limit: 4
  	# t.integer  "favicon_height",           limit: 4
  	# t.string   "favicon_content_type",     limit: 255
  	# t.integer  "favicon_file_size",        limit: 4
  end
end
