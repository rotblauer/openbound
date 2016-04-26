# require 'test_helper'

# class UploadTest < ActiveSupport::TestCase

#   def setup
#     @user = users(:michael)
#     @upload = @user.uploads.build(upload_file_name: "Lorem ipsum")
#   end

#   test "should be valid" do
#     assert @upload.valid?
#   end

#   test "user id should be present" do
#     @upload.user_id = nil
#     assert_not @upload.valid?
#   end

#   test "upload_file_name should be present " do
#     @upload.upload_file_name = "   "
#     assert_not @upload.valid?
#   end

#   test "upload_file_name should be at most 140 characters" do
#     @upload.upload_file_name = "a" * 141
#     assert_not @upload.valid?
#   end

#   test "order should be most recent first" do
#     assert_equal Upload.first, uploads(:most_recent)
#   end

# end
