class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :destroy]
  # after_action :require_admin, only: [:new, :create] if Rails.env.staging?

  def new
  end

  def create
    # Email+password authentication. 
    if params[:provider].nil?

      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        if user.activated?
          log_in user
          user.update_tracked_fields(request)
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          redirect_back_or projects_url
        else
          message  = "Account not activated. "
          message += "Check your email for the activation link."
          flash[:warning] = message
          redirect_to root_url
        end
      else
        flash.now[:danger] = 'Invalid email/password combination'
        render 'index/signin'
      end

    # Oauth provider authentication. 
    else 

      # TODO: make sure there is an email available for all users, ie Twitter Oauth. 
        # Will require new UI flow with confirmation -> activation. 

      auth = request.env["omniauth.auth"]

      # If not logged in. (Begin session.)
      if !logged_in?

        # Look for a LinkedAccount by provider+uid.
        account = LinkedAccount.find_by_provider_and_uid(auth["provider"], auth["uid"])

        # If there is no LinkedAccount by that provider+uid. 
        if account.nil? 

          # Look for a User with the oauth email. 
          user_by_auth_email = User.find_by(email: auth["info"]["email"])

          # If there is no User, either by provider+uid or email.
          if user_by_auth_email.nil?

            # Create user if no User or LinkedAccount found. 
            user = User.create_with_omniauth(auth)
            created_with_oauth = true
          
          # Else there is a user found by email. 
          else 

            # Use found User account by email and add (append to) User.linked_accounts 
            user = user_by_auth_email
            user.add_linked_account(auth)
            added_linked_account = true
          end

        # Else there is an existing LinkedAccount with an existing User. 
        else 

          # Update LA instance to reflect any available changes from the auth information. 
          account.update_from_auth(auth)

          # Set user through LinkedAccount.belongs_to. 
          user = account.user
        end 

        log_in user # => session[:user_id] = user.id
        welcome_message = "Welcome! "
        welcome_message += "You've signed in with your #{auth['provider']} as #{auth['info']['name']}." if created_with_oauth
        welcome_message += "We've added your #{auth['provider']} account (#{auth["info"]["name"]}) to your membership." if added_linked_account
        flash[:success] = welcome_message

      # Else logged_in? => true, add the linked account. 
      else 
        unless current_user.nil?
          user = current_user
          user.add_linked_account(auth)
        else 
          flash[:error] = "Uh oh! There was a strange problem..."
        end
        flash[:success] = "Great! We've connected your #{auth['provider']} account with your profile.\nFeel free to log in either way."
      end 


      redirect_to user
    end
  end

  # def require_admin
  #   unless current_user.admin == true
  #     flash[:warning] = "Sorry, only admins or devs allowed in here!"
  #     log_out if logged_in?
  #     redirect_to signin_path
  #   end
  # end

  def destroy
    log_out if logged_in?
    redirect_to projects_url
  end

end
