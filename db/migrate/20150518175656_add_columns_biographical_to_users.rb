class AddColumnsBiographicalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nutshell, :string
    add_column :users, :avatar, :string
    add_column :users, :ed_level, :string
  end
end
