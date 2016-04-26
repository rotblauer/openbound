class AddColumnRemoteFaviconUrlToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :remote_favicon_url, :string
  end
end
