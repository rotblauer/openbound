class CreateAffiliations < ActiveRecord::Migration

  def change

    add_column :schools, :users_counts, :integer, null: false, default: 0
    # rename_column :schools, :users_count, :affiliations_count
    add_column :users, :affiliations_count, :integer, null: false, default: 0


    create_table :affiliations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :school, index: true
      t.boolean :is_primary, null: false, default: true
      t.boolean :is_assignment, null: false, default: true
      t.boolean :is_preference, null: false, default: false
      t.boolean :is_active, null: false, default: true
      t.string :concentration
      t.boolean :graduated
      t.boolean :is_fallback

      t.timestamps null: false
    end
    add_foreign_key :affiliations, :users
    add_foreign_key :affiliations, :schools

    # Init.

    spy_u_id = School.friendly.find('spy-university').id


    User.all.each do |user|

      uid = user.id
      sid = user.school_id
      school_name = School.find(sid).Institution_Name
      if sid == spy_u_id
        defaulty = true
      else
        defaulty = false
      end

      aff = Affiliation.new(
        user_id: uid,
        school_id: sid,
        is_fallback: defaulty
        )

      if aff.save
        puts "Saved affiliation for #{user.name} at #{school_name} -  Defaulty? #{defaulty}; ? #{sid} == #{spy_u_id}"
      else
        puts "Shit."
      end
    end



  end
end
