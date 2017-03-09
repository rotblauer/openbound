class UsersController < ApplicationController
  # before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy] #
  before_action :correct_user,   only: [:edit, :update, :bookmarks, :anonymousers]
  before_action :admin_user,     only: :destroy
  before_action :set_project_partial_size, only: [:bookmarks, :anonymousers, :show]
  # before_filter :disable_base_upload_forms
  respond_to :html, :json, :js

  include ApplicationHelper

  def bookmarks
    @on_bookmarks = true
    @on_public = false
    @on_anonymousers = false
    # @user = User.friendly.find(params[:id])
    @recommendations = @user.recommendeds.first(10)

    @user_bookmarks_count = @user.bookmarks.where(bookmarked: true).count

    # bookmarks = current_user.bookmarks.where(bookmarked: true)
    # bookmarked_works = Work.joins(:bookmarks).order("bookmarks.created_at desc").merge(bookmarks)
    # bookmarked_works = Work.joins(:bookmarks).merge(bookmarks)
    #
    if @user_bookmarks_count > 0
      # @search = Project.search do
      #   if !params[:project_id].nil? # load more from n -> ...
      #     with(:id).less_than(params[:project_id])
      #   end
      #   order_by(:created_at, :desc)
      #   facet :context_list
      #   facet :content_list
      #   paginate(page: params[:page] || 1, :per_page => 24)
      #   # match works against list of user's bookmarks
      #   any_of do
      #     current_user.bookmarks.where(bookmarked: true).each do |bookmark|
      #       with(:id, bookmark.project_id)
      #     end
      #   end
      #   any do
      #     if params[:context].present?
      #       any_of do # changing to all_of does "drill down" style, this more "browsy" style
      #         params[:context].each do |tag|
      #           with(:context_list, tag)
      #         end
      #       end
      #     end
      #     if params[:content].present?
      #       any_of do # changing to all_of does "drill down" style, this more "browsy" style
      #         params[:content].each do |tag|
      #           with(:content_list, tag)
      #         end
      #       end
      #     end
      #   end
      # end
      # @projects = @search.results
      # @total_results = @projects.total_entries
      @projects = Project
                  .where(:id => current_user.bookmarks.where(bookmarked: true).map { |b| b.id })
                  .search(id: params[:project_id],
                                 page: params[:page] || 1,
                                 per_page: 24,
                                 tags: params[:tag] || []
                                )
      @total_results = @projects.count

    else
      @projects = []
    end



    render template: 'users/show'

  end

  def anonymousers
    @on_anonymousers = true
    @on_public = false
    @on_bookmarks = false
    @recommendations = @user.recommendeds.first(10)
    # @user = User.friendly.find(params[:id])

    # @search = Project.search do
    #   with(:id).less_than(params[:project_id]) if params[:project_id] # load more from n -> ...
    #   with(:user_id, User.friendly.find(params[:id]).id)
    #   with(:anonymouse, true)
    #   order_by(:created_at, :desc)
    #   facet :context_list
    #   facet :content_list
    #   paginate(page: params[:page] || 1, :per_page => 24)

    #   any do
    #     if params[:context].present?
    #       any_of do # changing to all_of does "drill down" style, this more "browsy" style
    #         params[:context].each do |tag|
    #           with(:context_list, tag)
    #         end
    #       end
    #     end
    #     if params[:content].present?
    #       any_of do # changing to all_of does "drill down" style, this more "browsy" style
    #         params[:content].each do |tag|
    #           with(:content_list, tag)
    #         end
    #       end
    #     end
    #   end
    # end
    # @projects = @search.results
    # @total_results = @projects.total_entries
    @projects = Project
                .where(anonymouse: true)
                .where(user_id: User.friendly.find(params[:id]).id)
                .search(id: params[:project_id],
                               page: params[:page] || 1,
                               per_page: 24,
                               tags: params[:tag] || []
                              )
    @total_results = @projects.count


    render template: 'users/show'
  end

  def show
    @on_public = true
    @on_bookmarks = false
    @on_anonymousers = false
    @user = User.friendly.find(params[:id])

    impressionist(@user) # would show how many views the User has
    @recommendations = @user.recommendeds.first(10)

    # @search = Project.search do
    #   with(:id).less_than(params[:project_id]) if params[:project_id] # load more from n -> ...
    #   with(:user_id, User.friendly.find(params[:id]).id)
    #   with(:anonymouse, false) # works that belong to the User and are not anonymouse
    #   order_by(:created_at, :desc)
    #   facet :context_list
    #   facet :content_list
    #   paginate(page: params[:page] || 1, :per_page => 20)

    #   any do
    #     if params[:context].present?
    #       any_of do # changing to all_of does "drill down" style, this more "browsy" style
    #         params[:context].each do |tag|
    #           with(:context_list, tag)
    #         end
    #       end
    #     end
    #     if params[:content].present?
    #       any_of do # changing to all_of does "drill down" style, this more "browsy" style
    #         params[:content].each do |tag|
    #           with(:content_list, tag)
    #         end
    #       end
    #     end
    #   end
    # end
    # @projects = @search.results
    # @total_results = @projects.total_entries

    @projects = Project
                .where(user_id: User.friendly.find(params[:id]).id)
                .where(anonymouse: false)
                .search(id: params[:project_id],
                               page: params[:page] || 1,
                               per_page: 24,
                               tags: params[:tag] || []
                              )
    @total_results = @projects.count
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save!
      @user.send_activation_email
      flash[:warning] = "Awesome! You're almost there. Please check your email to activate your account."
      redirect_to projects_url
    else
      render 'index/signin'
    end
  end

  def edit

    ### The following I have used for testing statistics.
    ##
    #
    @bookmarks_count = @user.bookmarks.where(bookmarked: true).count # <-- bookmarks he has made
    @projects = @user.projects.all # <-- projects he has made
    @gradients_dished_out = @user.gradients.all # <-- gradients he has made

    @projects.each do |w|
      c = Bookmark.where(project_id: w.id).count
      @d =+ c
      # e = Gradient.where(project_id: w.id).count
      # @f =+ e
    end
    @projects_of_his_bookmarked = @d # <-- count bookmarks on his projects
    # @gradients_received = @f # <-- count gradients on his projects



  end

  def update
    # @user = User.friendly.find(params[:id])
    respond_to do |format|
      if @user.update!(user_params)
        format.html {
          flash[:success] = "Profile updated. Cool!"
          redirect_to edit_user_path(@user) }
        format.json {
          render json: @user
        }
      else
        format.html {
          render 'edit' }
        format.json {
          render json: @user
        }
      end
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.friendly.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
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

    # Confirms the correct user.
    def correct_user
      @user = User.friendly.find(params[:id])
      unless current_user?(@user)
        flash[:warning] = "No thank you."
        redirect_to(@user)
      end
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation, :superman, :school_id, :nutshell, :avatar)
  	end

    def set_project_partial_size
      @bigger_partials = true
    end

end
