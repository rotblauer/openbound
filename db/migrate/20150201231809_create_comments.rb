class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :user_id
      t.string :work_id
      t.text :comment

      t.timestamps null: false
    end
  end
end