require 'faker'

FactoryGirl.define do
  
  # Basic new user. 
  factory :new_user, class: User do |f|
  	f.name "isaac"
  	f.email "isaac@bowdoin.edu"
  	f.password "fluffy"
  end

  # Invalid user.
  factory :invalid_user, parent: :new_user do |f|
  	f.email "poser@gmail.com"
  end

  # Normal activated. 
  factory :isaac, aliases: [:author, 
														 :commenter, 
														 :grader, 
														 :bookmark_fiend, 
														 :student,
														 :tagger], parent: :new_user do |f|
  	f.created_at (Time.zone.now - 2.hours)
  	f.updated_at (Time.zone.now - 1.hour)
  	f.password_digest User.digest('fluffy')
  	f.admin false
  	f.activation_digest User.digest(User.new_token)
  	f.activated true
  	f.activated_at Time.zone.now
  	f.remember_digest nil
  	f.school_id 1077
  	f.superman false
  	f.slug 'isaac'
  end

  # Non-activated user. 
  factory :non_activated_user, parent: :isaac do |f|
  	f.activated false
  end

  # Normal other guy. 
  factory :james, parent: :isaac do |f|
  	f.name "james"
  	f.email "other@bowdoin.edu"
  	f.slug "james"
  end

  # Admin
  factory :admin, parent: :isaac do |f|
  	f.admin true
  end






end
