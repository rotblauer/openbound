class AddColumnAccesstokenToLinkedAccounts < ActiveRecord::Migration
  def change
    add_column :linked_accounts, :accesstoken, :string
  end
end
