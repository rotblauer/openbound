class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :upload_file_name
      t.string :upload_content_type
      t.integer :upload_file_size
      t.datetime :upload_updated_at
      t.datetime :created_at
      t.datetime :updated_at
      t.references :user, index: true

      t.timestamps null: false
    end
    add_index :uploads, [:user_id, :created_at]
  end
end
