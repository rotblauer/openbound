require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    user = users(:Isaac)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Openbound account activation!", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  test "password_reset" do
    user = users(:Isaac)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Reset your Openbound password!", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  test "email_update" do
    user = users(:Isaac)
    user.new_email = 'isaac@columbia.edu'
    user.email_update_token = User.new_token
    mail = UserMailer.email_update(user)
    assert_equal "Change your Openbound password!", mail.subject
    assert_equal [user.new_email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.email_update_token,        mail.body.encoded
    assert_match CGI::escape(user.uuid), mail.body.encoded
  end

end