class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.references :user, index: true
      t.references :work, index: true
      t.boolean :bookmarked, null: false

      t.timestamps null: false
    end
    add_foreign_key :bookmarks, :users
    add_foreign_key :bookmarks, :works
  end
end
