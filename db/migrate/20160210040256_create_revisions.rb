class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.references :work, index: true
      t.references :project, index: true
      t.text :data, :limit => 10.megabyte

      t.timestamps null: false
    end
    add_foreign_key :revisions, :works
    add_foreign_key :revisions, :projects
  end
end
