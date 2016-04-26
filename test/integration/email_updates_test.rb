require 'test_helper'

class EmailUpdatesTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:Isaac)
  end

  test "email updates" do 
    log_in_as(@user)
  	get new_email_update_path
  	assert_template 'email_updates/new'
  	# Invalid email: non-present
  	post email_updates_path, email_update: { new_email: ""}
  	assert_not flash.empty?
  	assert_template 'email_updates/new'
    # Invalid email: non-formatted right
    post email_updates_path, email_update: { new_email: "asdf"}
    assert_not flash.empty?
    assert_template 'email_updates/new'
    # Invalid email: non-unique
    post email_updates_path, email_update: { new_email: "houdini@bowdoin.edu"} # this is Admin Houdini's
    assert_not flash.empty?
    assert_template 'email_updates/new'
  	# Valid email
  	post email_updates_path, email_update: { new_email: "isaac@columbia.edu" }
  	assert_not_equal @user.email_update_digest, @user.reload.email_update_digest
    assert_equal @user.new_email_confirmed, false
  	assert_equal 1, ActionMailer::Base.deliveries.size
  	assert_not flash.empty?
  	assert_redirected_to edit_user_path(@user)
  	# Email update form.
  	user = assigns(:user)
  	# Wrong new_email.
  	get edit_email_update_path(user.email_update_token, new_email: "")
  	assert_redirected_to root_url
  	# Inactive user
  	user.togge!(:activated)
  	get edit_email_update_path(user.email_update_token, new_email: user.new_email)
  	assert_redirected_to root_url
  	# Right new_email, wrong token
  	get edit_email_update_path('wrong_token', new_email: user.new_email)
  	assert_redirected_to root_url
  	# Right new_email, right token
  	get edit_email_update_path(user.email_update_token, new_email: user.new_email)
    assert_equal @user.new_email_confirmed, true

  	assert_not flash.empty?
  	assert_redirected_to edit_user_path(@user)

    assert_equal @user.email, 'isaac@columbia.edu'
  end


end