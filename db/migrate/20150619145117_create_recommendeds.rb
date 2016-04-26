class CreateRecommendeds < ActiveRecord::Migration
  def change
    create_table :recommendeds do |t|
      t.string :work_id, null: false
      t.string :user_id, null: false

      t.timestamps null: false
    end
  end
end
