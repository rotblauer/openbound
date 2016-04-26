class CreateDiffs < ActiveRecord::Migration
  def change
    create_table :diffs do |t|
      t.integer :work1, null: false
      t.integer :work2, null: false
      t.references :project, index: true
      t.text :diff_md, :limit => 10.megabyte
      t.text :diff_html, :limit => 10.megabyte
      t.text :diff_md, :limit => 10.megabyte # oops

      t.timestamps null: false
    end
    add_foreign_key :diffs, :projects
  end
end
