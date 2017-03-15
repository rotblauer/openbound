require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:User_2)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    assert is_logged_in?

    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name:  "",
                                    email: "foo@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    @user.reload
    assert_not @user.name == ""
    assert_not @user.email == "foo@invalid"
    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    assert is_logged_in?

    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "moomooloomoo"
    # email = "foo@bar.edu"
    patch user_path(@user), user: { name:  name,
                                    email: @user.email,
                                    password:              "fluffy",
                                    password_confirmation: "fluffy"
                                  }
    assert_not flash.empty?
    assert_redirected_to user_edit_path(@user) # "/members/#{name}/edit"
    @user.reload
    assert_equal @user.name,  name
    # assert_equal @user.email, email
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name  = "Foo Bar"
    email = "foo@bar.edu"
    patch user_path(@user), user: { name:  name,
                                    email: email,
                                    password:              "fluffy",
                                    password_confirmation: "fluffy" }
    assert_not flash.empty?
    assert_redirected_to '/members/foo-bar/edit'
    @user.reload
    assert_equal @user.name,  name
    assert_equal @user.email, email
  end

end
