# encoding: utf-8
class ApplicationController < ActionController::Base
 include SessionsHelper
 include ApplicationHelper

  before_filter :disable_base_upload_forms
  before_filter :redirect_to_org if !Rails.env.development? #Rails.env.production? || .stag
  # before_action :require_login if Rails.env.staging?
  after_filter :track_action

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # after_filter :set_csrf_cookie_for_ng
  # skip_before_action :verify_authenticity_token, if: :json_request?

  # def set_csrf_cookie_for_ng
  #   cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  # end

  # http://stackoverflow.com/questions/10629397/how-to-disable-http-strict-transport-security
  # It should be documented that once you enable the 'force_ssl' option in Rails, the only way to disable it is to have all your visitors clear their browser cache. :(
  # If this wasn't the case, you'd be vulnerable to SSL stripping which is what HSTS is designed to mitigate. Nothing to do with Rails.
  # response.headers["Strict-Transport-Security"] = 'max-age=0'
  before_filter :unset_ssl

  def unset_ssl
    response.headers["Strict-Transport-Security"] = 'max-age=0'
  end

  def require_login
    unless logged_in?
      render 'index/signin'
    end
  end

  protected

    def track_action
      # https://github.com/ankane/ahoy/issues/98
      ahoy.track "Processed #{controller_name}##{action_name}", request.filtered_parameters.except("work").except("project").except("diff").except("user") unless controller_name == "work" and action_name == "get"
      # puts "request.filtered_parameters => #{request.filtered_parameters}"
    end

  private

    # http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection.html
    # def json_request?
    #   request.format.json?
    # end

    # # In Rails 4.2 and above
    def verified_request?
      super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end


    def redirect_to_org
      domain_to_redirect_to = 'openbound.org'
      domain_exceptions = ['openbound.org', 'www.openbound.org', 'staging.openbound.org']
      should_redirect = !(domain_exceptions.include? request.host)
      # if not trying to get to staging
      # if !['staging.openbound.org'].include? request.host
      new_url = "#{request.protocol}#{domain_to_redirect_to}#{request.fullpath}"
      # else
      #   new_url = "ec2-52-27-198-224.us-west-2.compute.amazonaws.com#{request.fullpath}"
      # end
      redirect_to new_url, status: :moved_permanently if should_redirect and Rails.env.production?
    end

end
