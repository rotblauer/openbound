class CreateLinkedAccounts < ActiveRecord::Migration
  def change
    create_table :linked_accounts do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :image_url
      t.string :location
      t.text :oauth_json, :limit => 2.megabyte

      t.timestamps null: false
    end
    add_index :linked_accounts, :uid
    add_index :linked_accounts, [:provider, :uid], name: "index_on_provider_and_uid"
    add_foreign_key :linked_accounts, :users
  end
end
