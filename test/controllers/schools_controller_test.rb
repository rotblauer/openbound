require 'test_helper'

class SchoolsControllerTest < ActionController::TestCase

	def setup
		@user = users(:Isaac)
		@school = schools(:Bowdoin)
	end

	test "should redirect index if not logged in" do
		get :index
		assert_not flash.empty?
		assert_redirected_to login_url
	end
		
	test "should redirect show if not logged in" do
		get :show, id: @school
		assert_not flash.empty?
		assert_redirected_to login_url
	end

	test "should show and index if logged in" do
		log_in_as(@user)
		get :show, id: @school
		assert_response :success
		get :index
		assert_response :success
	end

end