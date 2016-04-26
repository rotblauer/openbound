class AdminsController < ApplicationController
  include ApplicationHelper
  before_action :ensure_admin, only: [:analytics]


  def analytics
    disable_footer
  end

  private 
    def ensure_admin 
      redirect_to root_path unless !current_user.nil? && current_user.admin
    end

end
