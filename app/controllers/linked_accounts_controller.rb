class LinkedAccountsController < ApplicationController
  before_action :correct_user 

  def destroy
    linked_account = LinkedAccount.find(params[:linked_account_id])
    user = linked_account.user

    pre_delete_linked_accounts_count = user.linked_accounts.count
    
    linked_account.destroy!

    # If there are no remaining connected Oauth accounts and the user was created with
    # Oauth, then we'll need to log the user out and send a password reset email. 
    if (user.has_password == false) && pre_delete_linked_accounts_count == 1
      # user.update_attributes!(has_oauth: false) <-- moved to linked_account.rb callback
      user.create_reset_digest
      user.send_password_reset_email
      flash[:warning] = "You've been logged out. Please check your email for password reset instructions."
      log_out 
      redirect_back_or user
    else 
      # user.update_attributes!(has_oauth: false) if pre_delete_linked_accounts_count == 1
      flash[:success] = "Account successfully disconnected."
      redirect_back_or user
    end 
    
  end

  private 

    # Confirms the correct user.
    def correct_user
      user = User.friendly.find(params[:id])
      unless current_user?(user)
        flash[:warning] = "No thank you."
        redirect_to root_url
      end
    end


end
