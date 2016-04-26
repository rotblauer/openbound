require 'rails_helper'
include SpecTestHelper

RSpec.describe BookmarksController, :type => :controller do
	it 'does not let just anybody do bookmarks' do 
		bookmark = FactoryGirl.create(:bookmark)
		patch :bookmarker, user_id: bookmark.user_id, work_id: bookmark.work_id
		expect(bookmark.bookmarked).not_to eq(false)
	end
	it 'does let logged-in user do bookmarks' do 
		user = FactoryGirl.create(:isaac)
		bookmark = FactoryGirl.create(:bookmark, user_id: user.id)
		login(user)
		patch :bookmarker, user_id: user.id, work_id: bookmark.work_id
		expect(bookmark.bookmarked).to eq(false)
	end


end
