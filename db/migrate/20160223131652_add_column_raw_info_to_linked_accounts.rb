class AddColumnRawInfoToLinkedAccounts < ActiveRecord::Migration
  def change
    add_column :linked_accounts, :raw_info, :text, :limit => 1.megabyte
  end
end
