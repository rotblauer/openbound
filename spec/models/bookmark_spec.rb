require 'rails_helper'

RSpec.describe Bookmark, :type => :model do
	
	it 'validates presence of work_id' do 
		bookmark = FactoryGirl.build(:bookmark, user_id: 1, work_id: nil)
		expect(bookmark).not_to be_valid
	end
	it 'validates presence of user_id' do 
		bookmark = FactoryGirl.build(:bookmark, user_id: nil, work_id: 1)
		expect(bookmark).not_to be_valid
	end
  it 'validates uniqueness on user_id scope: work_id' do 
  	bm1 = FactoryGirl.create(:bookmark, user_id: 1, work_id: 1)
  	bm2 = FactoryGirl.build(:bookmark, user_id: 1, work_id: 1)
  	expect(bm2).not_to be_valid
  end
  
end
