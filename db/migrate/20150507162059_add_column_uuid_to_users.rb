class AddColumnUuidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uuid, :string, unique: true
  end
end
