class AccountActivationsController < ApplicationController
  before_filter :cgi_unescape_params, only: :edit

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Welcome, #{user.name}! You're in."
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end

  private

  # This unescapes url-parameterized characters, ie @ => %40, which was causing User lookup to fail on the confirm email_update link. 
  def cgi_unescape_params
    params.each { |k, v| params[k] = CGI.unescape(v) }
  end

  
end