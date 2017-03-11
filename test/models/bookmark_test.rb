require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase

  # test "should have a user_id, work_id, and bookmarked" do
  # 	bookmark = Bookmark.new(user_id: nil, bookmarked: true, work_id: 1)
  # 	assert_not bookmark.save
  # 	bookmark = Bookmark.new(user_id: 1, bookmarked: nil, work_id: 1)
  # 	assert_not bookmark.save
  # 	bookmark = Bookmark.new(user_id: 1, bookmarked: true, work_id: nil)
  # 	assert_not bookmark.save
  # end

  # test "should have a unique user_id+work_id" do
  # 	bookmark = Bookmark.new(user_id: 1, work_id: 1, bookmarked: true)
  # 	assert bookmark.save
  # 	bookmarkcopy = Bookmark.new(user_id: 1, work_id: 1, bookmarked: false)
  # 	assert_not bookmarkcopy.save
  # end

end
