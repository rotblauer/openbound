class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :name
      t.string :document
      t.references :user, index: true

      t.timestamps null: false
    end
    add_index :works, [:user_id, :created_at]
  end
end
