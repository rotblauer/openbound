class CreateGradients < ActiveRecord::Migration
  def change
    create_table :gradients do |t|
      t.integer :grad
      t.references :user, index: true
      t.references :work, index: true

      t.timestamps null: false
    end
    add_foreign_key :gradients, :users
    add_foreign_key :gradients, :works
  end
end
