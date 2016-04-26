class BookmarksController < ApplicationController
  before_action :logged_in_user, only: [:bookmarker]
  before_filter :set_project
  respond_to :json, :html, :js

  def bookmarker
    # session[:return_to] ||= request.referer
    bookmark = current_user.bookmarks.find_by(project_id: @project.id)

    # If the bookmark exists, destroy it. 
    if !bookmark.nil?
      respond_to do |format|
        if bookmark.destroy!
          format.html {
            flash[:info] = "Un-bookmarked!"
            redirect_to :back #session.delete(:return_to)
          }
          format.json { 
            head :no_content 
          }
          format.js {
          }
        else 
          format.html {
            flash[:warning] = "Bookmark failure."
            redirect_to :back # session.delete(:return_to)
          }
          format.json { head :no_content }
          format.js {}
        end
      end
    else
      bookmark = current_user.bookmarks.build(project_id: @project.id, bookmarked: true)
      respond_to do |format|
        if bookmark.save!
          format.html {
            flash[:success] = "Bookmarked!"
            redirect_to :back #session.delete(:return_to)
          }
          format.json { 
            head :no_content 
          }
          format.js {
          }
        else 
          format.html {
            flash[:warning] = "Bookmark failure."
            redirect_to :back # session.delete(:return_to)
          }
          format.json { head :no_content }
          format.js {}
        end
      end
    end 
  end

	private

	  def set_project
	    # @work = Work.friendly.find(params[:work_id])
      @project = Project.friendly.find(params[:project_id])
	  end

	  def bookmark_params
	    params.require(:bookmark).permit(:bookmarked)
	  end

end