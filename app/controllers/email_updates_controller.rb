class EmailUpdatesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]
  before_action :get_current_user, only: [:new, :create]
  before_action :check_for_cancel, only: [:create]
  before_filter :cgi_unescape_params, only: :edit
  before_action :get_user_by_params, only: :edit
	before_action :valid_user, only: :edit
	before_action :check_expiration, only: :edit

  def new
  end

  def create
    if !User.find_by(email: params[:email_update][:new_email]).present? && @user.update_attributes(new_email: params[:email_update][:new_email])
      @user.create_email_update_digest(params[:email_update][:new_email])
  		@user.send_email_update_email
  		flash[:info] = "An email has been sent to #{@user.new_email} for confirmation!"
  		redirect_to edit_user_path(@user)
    else
      flash[:danger] = "It looks like that email isn't valid."
      render 'new'
    end
  end

  def edit
    if @user.update_confirmed_email(params[:new_email])
      flash[:success] = "Your email has been successfully changed to #{@user.email}!"
      redirect_to edit_user_path(@user)
    else
      flash[:danger] = "Failed to update email. Please try again."
      redirect_to new_email_update_path
      Rails.logger.info(@user.errors.messages.inspect)
    end
  end

  def update
  end


  private
    
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to signin_url
      end
    end

  	def get_current_user
  		@user = current_user
  	end

    # This unescapes url-parameterized characters, ie @ => %40, which was causing User lookup to fail on the confirm email_update link. 
    def cgi_unescape_params
      params.each { |k, v| params[k] = CGI.unescape(v) }
    end

    def get_user_by_params
      @user = User.find_by(new_email: params[:new_email])
    end

  	def valid_user 
  		unless (@user && @user.activated? && @user.authenticated?(:email_update, params[:id]))
  			redirect_to root_url
  		end
  	end

  	def check_expiration
  		if @user.email_update_expired?
  			flash[:danger] = "Your confirmation email has expired!"
  			redirect_to new_email_update_url
  		end
  	end

    def check_for_cancel
      if params[:commit] == "Cancel"
        redirect_to edit_user_path(@user)
      end
    end

end



private

 
