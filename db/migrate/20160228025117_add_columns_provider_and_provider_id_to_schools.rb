class AddColumnsProviderAndProviderIdToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :provider, :string
    add_column :schools, :provider_id, :string
  end
end
