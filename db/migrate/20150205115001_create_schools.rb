class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :Institution_ID
      t.string :Institution_Name
      t.string :Institution_Address
      t.string :Institution_City
      t.string :Institution_State
      t.string :Institution_Zip
      t.string :Institution_Phone
      t.string :Institution_OPEID
      t.string :Institution_IPEDS_UnitID
      t.string :Institution_Web_Address
      t.string :Campus_ID
      t.string :Campus_Name
      t.string :Campus_Address
      t.string :Campus_City
      t.string :Campus_State
      t.string :Campus_Zip
      t.string :Campus_IPEDS_UnitID
      t.string :Accreditation_Type
      t.string :Agency_Name
      t.string :Agency_Status
      t.string :Program_Name
      t.string :Accreditation_Status
      t.string :Accreditation_Date_Type
      t.string :Periods
      t.string :Last_Action
      t.string :school_domain_slice

      t.timestamps null: false
    end
  end
end
