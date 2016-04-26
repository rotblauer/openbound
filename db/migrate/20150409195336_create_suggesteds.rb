class CreateSuggesteds < ActiveRecord::Migration
  def self.up
    create_table :suggesteds do |t|
      t.integer :user_id
      t.integer :work_id, null: false
      t.integer :author_id, null: false
      t.string :suggestion, limit: 128
      t.boolean :approved, null: false, default: false
      t.boolean :open, null: false, default: true
      t.datetime :created_at
      t.datetime :updated_at
      t.string :suggester_ip 

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :suggesteds 
  end
end
