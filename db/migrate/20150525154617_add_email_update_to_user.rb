class AddEmailUpdateToUser < ActiveRecord::Migration
  def change
    add_column :users, :new_email, :string
    add_column :users, :email_update_digest, :string
    add_column :users, :email_update_sent_at, :datetime
  end
end
