class UserMailer < ApplicationMailer
  default from: "team@rstacks.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Rstacks account activation!"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Reset your Rstacks password!"
  end

  def email_update(user)
    @user = user
    mail to: user.new_email, subject: "Change your Rstacks email!"
  end
  
  # Add email_update_notice(user)
  # send email to existing email notifying of impending change. 

end
