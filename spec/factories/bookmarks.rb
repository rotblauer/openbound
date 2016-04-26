FactoryGirl.define do
  factory :bookmark do |b|
  	b.user_id 1
  	b.work_id 1
  	b.bookmarked true
  	b.created_at { 2.hours.ago }
  	b.updated_at Time.zone.now
  end

end
