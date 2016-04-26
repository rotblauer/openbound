class PasswordResetsController < ApplicationController
  before_filter :cgi_unescape_params, only: :edit
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
  	if @user
  		@user.create_reset_digest
  		@user.send_password_reset_email
  		flash[:info] = "An email has been sent to you with password reset instructions!"
  		redirect_to root_url
  	else
  		flash.now[:danger] = "We couldn't find that email address in our stacks :("
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if password_blank?
      flash.now[:danger] = "Hey! You've got to enter a password!"
      render 'edit'
    elsif @user.update(user_params) && @user.update_attributes(has_password: true)
      log_in @user
      flash[:success] = "Your password has been reset!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    # This unescapes url-parameterized characters, ie @ => %40, which was causing User lookup to fail on the confirm email_update link. 
    def cgi_unescape_params
      params.each { |k, v| params[k] = CGI.unescape(v) }
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # Returns true if password is blank.
    def password_blank?
      params[:user][:password].blank?
    end

    # Before filters. 

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Checks expiration date of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Your super secret password-reset code has expired!"
        redirect_to new_password_reset_url
      end
    end
end
