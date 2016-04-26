FactoryGirl.define do
  factory :harvard, class: School do |s|
	s.Institution_ID 8382349
    s.Institution_Name "Hippoputaus University"
    s.Institution_Address "Harvard Square 1"
    s.Institution_City "Cambridge"
    s.Institution_State "MA"
    s.Institution_Zip "12345"
    s.Institution_Phone "123-345-2131"
    s.Institution_OPEID "2134asd"
    s.Institution_IPEDS_UnitID "asdf"
    s.Institution_Web_Address "www.harvardus.edu"
    s.Accreditation_Type "ok"
    s.Agency_Name "white ugys"
    s.Agency_Status "snog"
    s.Program_Name "trying"
    s.Accreditation_Status "wishing"
    s.Accreditation_Date_Type "yesterday"
    s.Periods "too soon"
    s.Last_Action "absolved"
    s.school_domain_slice "harvardus.edu"
    s.created_at { 200.years.ago }
    s.updated_at { Time.zone.now }
    s.works_count 0
    s.users_count 0
    #s.slug # <-- should create automatic ja??
  end

end
