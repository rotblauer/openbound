class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :user, index: true
      t.references :school, index: true
      t.string :author_name
      t.text :file_content_md, :limit => 10.megabyte
      t.text :file_content_html, :limit => 10.megabyte
      t.text :file_content_text, :limit => 10.megabyte
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :works_count, :default => 0, :null => false
      t.boolean :is_public, :default => true, :null => false
      t.boolean :is_collaborative, :default => true, :null => false

      t.timestamps null: false
    end
    add_foreign_key :projects, :users
    add_foreign_key :projects, :schools
  end
end
