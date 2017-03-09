# require 'time_pretty.rb'
class ProjectsController < ApplicationController
  # include PrettyDate

  before_action :logged_in_user, only: [:new, :create, :destroy] # application_helper?
  before_action :set_project, only: [:show, :edit, :update, :destroy, :add_version, :change_policy]
  before_action :correct_user, only: [:edit, :update, :destroy, :change_policy]
  # before_filter :disable_base_upload_forms
  respond_to :json, :html, :js

  include ApplicationHelper

  def index

    tags = []
    schools = []

    if params[:tag].present?
      params[:tag].each do |tag|
        tags.push tag
      end
    end

    if params[:school_name].present?
      params[:school_name].each do |school|
        schools.push school
      end
    end

    q = params[:search]
    q = nil if params[:search].blank?

    @projects = Project.search(query: q,
                         tags: tags,
                         schools: schools,
                         id: params[:id],
                         page: params[:page] || 1,
                         per_page: params[:per_page] || 24)

    # # Sunspot Solr :search
    # @search = Project.search do 
    #   fulltext params[:search]
    #   order_by(:created_at, :desc) # created_at
    #   facet :context_list
    #   facet :content_list
    #   facet :school_name
    #   with(:id).less_than(params[:id]) if params[:id] # load more from n+ -> 
    #   # with(:updated_at).less_than(params[:updated_at]) if params[:updated_at]

    #   ## [copy & paste from works_controller]
    #   # if searching, include more results per page
    #   if params[:search] || params[:tag]
    #     paginate(:page => params[:page] || 1, :per_page => 24)
    #   else 
    #     paginate(:page => params[:page] || 1, :per_page => 24)
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
    #     # http://localhost:3000/?page=5&school_name%5B%5D=University+of+Nevada+-+Reno&school_name%5B%5D=Bowdoin+College
    #     # with(:school_name, params[:school_name]) if params[:school_name].present?
    #     if params[:school_name].present? 
    #      any_of do # this allows for browsing Bowdoin and Cornell (where Bowdoin OR Cornell)
    #         params[:school_name].each do |school|
    #           with(:school_name, school) # if params[:school_name].present?
    #         end
    #       end
    #     end
    #   end
    # end
    # @projects = @search.results
    # @total_count = @projects.total_entries

    # Personalized. 
    if current_user
      user_school = current_user.school_primary
      @bookmarks = current_user.bookmarks(:project_id)
    end

    ## Calculating schools list for browsing by schools.
    #
      
      # ** NOTE: Schools are filtered and order by **works_count**, NOT projects_count
      # TODO: add projects_count attr to School and make it count here

    desired_number_of_school_facets = 10
    if @projects.any? 
      # Schools associated with resulting works (first page), 
      # could be [Bowdoin College, Bowdoin College, Bowdoin College, Colby College].
      project_schools = []
      # Array for unique resulting schools. 
      resulting_schools = []
      # For each project, push associated school name (string) to array. 
      @projects.each do |project|
        project_schools.push(project.school_name)
      end
      # Filter for only unique school names. 
      resulting_schools = project_schools.uniq
      # If there are not enough schools, append the list with well endowed schools. 
      if resulting_schools.count < desired_number_of_school_facets
        # How many schools to append. 
        diff = desired_number_of_school_facets - resulting_schools.count
        # Find schools which are not already included in the results, which have projects_count > 0. 
        non_resulting_schools_all = School.where.not(Institution_Name: resulting_schools).where('works_count > ?', 0).order('works_count desc').order('affiliations_count desc').all
        # Take first(diff) if there are more than diff returned. 
        if non_resulting_schools_all.count > diff
          non_resulting_schools = non_resulting_schools_all.first(diff)
        else 
          non_resulting_schools = non_resulting_schools_all
        end
        # Add their names to the array if there are any. 
        if !non_resulting_schools.empty?
          non_resulting_schools.each do |school|
            resulting_schools.push(school.Institution_Name)
          end
        end
        # Use names to query ActiveRecord objects. 
        @facet_schools = School.where(Institution_Name: resulting_schools).order('works_count desc').order('affiliations_count desc')
      # Else there are enough unique schools associated with the results. 
      else
        @facet_schools = School.where(Institution_Name: resulting_schools).where('works_count > ?', 0).order('works_count desc').order('affiliations_count desc')
      end
    # If there is not a search, return most endowed schools. 
    else
      @facet_schools = School.order('works_count desc').order('affiliations_count desc').order('updated_at desc').first(desired_number_of_school_facets)
    end

  end # end #index

  def testes
    @work1 = Work.first
    @work2 = Work.second
    @project = Project.last
    @diffs = Diff.all
  end

  def test_show
    @disable_footer = true
    @project = Project.first
    @works = @project.works.all
    @most_recent_work = @project.most_recent_work
    @diffs = @project.diffs.all
  end

  def testpartial
    @project = Project.first
  end

  # def go_to_user_most_recent_proj
  #   proj = current_user.projects.last
  #   redirect_to project_path(proj)
  # end

  def shelving_cart_edit

    respond_to do |format|
      if current_user 
        # TODO: where **a** work was created .... 
        @projects = current_user.projects.where(updated_at: 5000.minutes.ago..Time.now)
        format.html 
        format.json { render json: @projects }
        format.js {
          flash[:info] = "Thank you! Your work was successfully added to the library."
          render :js => "window.location = '#{snooty_librarian_path}'"
        }
        # @works = current_user.works.where(created_at: 2.months.ago..Time.now)
      else 
        flash[:warning] = 'Hold on there! Ya gotta be logged in!'
        redirect_to works_path
      end
    end
  end

  def show
    # (set_project is called in private)
    # @disable_footer = flase # call "custom" upload+import options inline
    # disable_base_upload_forms # application helper
    impressionist(@project)

    # show all works under this project (all versions)
    @works = @project.works.all
    @most_recent_work = @project.most_recent_work
    @diffs = @project.diffs.all

  end

  # add a work which will be assigned to existing project
  def add_version
    @disable_footer = true
    # show all works under this project (all versions)
    # @works = @project.works.all

  end

  def new
    @disable_footer = true
    # @project = current_user.projects.build
    # @diffs = Project.friendly.find('grandmas-coming-along-md').diffs.all
  end

  def create
    # this all handled through work#create
  end

  def change_policy
    #@work = Work.friendly.find(params[:id])
    @project.anonymouse = !@project.anonymouse
    respond_to do |format|
      if @project.save
        format.html {
          redirect_to :back#mystacks_path(anchor: 'uploaded-works')
          if @project.anonymouse
            flash[:info] = "Made #{@project.name || @project.file_name} the work of superman, aka #{@project.author_name}!"
          else 
            flash[:info] = "Made #{@project.name || @project.file_name} the work of #{@project.user.name} (that's you!)"
          end
        }
        format.json { head :no_content }
        format.js {}
      else
        format.html {
          redirect_to :back#mystacks_path(anchor: 'uploaded-works')
          flash[:warning] = "Failed to change the work's policy."
        }
        format.json { head :no_content }
        format.js {}
      end
    end
  end

  def edit
    # this is all b_i_p
  end

  def update
    respond_to do |format|
      if @project.update!(project_params)
        format.html { redirect_to @project
                      flash[:info] = 'Project successfully updated!'  }
        format.json { 
          render json: @project } 
      else
        format.html { render action: "edit" }
        format.json { 
          render json: @project
        } 
      end
    end
  end

  def destroy
    if @project.destroy
      respond_to do |format|
        format.html { flash[:info] = "Successfully deleted the project."
                      redirect_to projects_path }
        format.json { head :no_content }
        format.js   { 
          # render :layout => false 
          render :js => "window.location = '#{projects_path}'"
          flash[:success] = "Successfully <span style='color: red;'>deleted</span> #{@project.name}. Good riddance."
        }
      end
    end
  end

  private
    def set_project
      @project = Project.friendly.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :description, :context_list, :content_list, :author_name)
    end

    def correct_user
      if 
        set_project
        @project.user == current_user
      else
        redirect_to root_url
        flash[:danger] = "Hey, that ain't yo project!"
      end
    end
end
