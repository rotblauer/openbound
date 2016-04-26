class RenameLinkedAccountsJsonColumns < ActiveRecord::Migration
  def change
  	rename_column :linked_accounts, :oauth_json, :oauth_info_json
  	rename_column :linked_accounts, :raw_info, :oauth_raw_info_json
  end
end
