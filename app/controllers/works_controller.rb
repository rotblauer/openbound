require 'pandoc-ruby'

class WorksController < ApplicationController

  include Filetypeable

	before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :set_work, only: [:show, :edit, :destroy, :change_policy, :recommend]
  before_action :correct_user, only: [:edit, :update, :destroy, :change_policy, :recommend]

  # http://apidock.com/rails/ActiveSupport/Callbacks/ClassMethods/skip_callback
  before_action :set_update_callback_skip_for_create, only: [:create, :google_import]
  before_action :set_update_callback_skip, only: [:create, :google_import, :begin_new_version]
  before_action :set_create_callback_skip, only: [:begin_new_version]
  respond_to :json, :html, :js
  skip_before_filter :verify_authenticity_token, only: [:google_import, :update]

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

    @works = Work.search(query: params[:search] || nil,
                         tags: tags,
                         schools: schools,
                         id: params[:id],
                         page: params[:page] || 1,
                         per_page: params[:per_page] || 24)

    # @search = Work.search do
    #   fulltext params[:search]
    #   order_by(:created_at, :desc)
    #   facet :context_list
    #   facet :content_list
    #   facet :school_name
    #   with(:is_latest_version, true)
    #   with(:id).less_than(params[:id]) if params[:id] # load more from n -> ...

    #   if params[:search] || params[:tag]
    #     paginate(:page => params[:page] || 1, :per_page => 24)
    #   else
    #     paginate(:page => params[:page] || 1, :per_page => 24)
    #   end

    #   any do
    #     if params[:context].present?
    #       any_of do
    #         params[:context].each do |tag|
    #           with(:context_list, tag)
    #         end
    #       end
    #     end
    #     if params[:content].present?
    #       any_of do
    #         params[:content].each do |tag|
    #           with(:content_list, tag)
    #         end
    #       end
    #     end
    #     if params[:school_name].present?
    #      any_of do
    #         params[:school_name].each do |school|
    #           with(:school_name, school) # if params[:school_name].present?
    #         end
    #       end
    #     end
    #   end
    # end
    # @works = @search.results



    # Personalize info for current user.
    if current_user
      user_school = current_user.school_primary
      @bookmarks = current_user.bookmarks(:work_id)
      # Show works the user added today. Located in _multiple_upload partial.
      @my_newly_uploaded_works = Work.where(user_id: current_user.id, created_at: (DateTime.now.at_beginning_of_day.utc..Time.now.utc)).order('created_at DESC').first(10)
    end

    ## Calculating schools list for browsing by schools.
    #
    desired_number_of_school_facets = 10
    if @search.results.any?
      # Schools associated with resulting works (first page),
      # could be [Bowdoin College, Bowdoin College, Bowdoin College, Colby College].
      work_schools = []
      # Array for unique resulting schools.
      resulting_schools = []
      # For each work, push associated school name (string) to array.
      @works.each do |work|
        work_schools.push(work.school.Institution_Name)
      end
      # Filter for only unique school names.
      resulting_schools = work_schools.uniq
      # If there are not enough schools, append the list with well endowed schools.
      if resulting_schools.count < desired_number_of_school_facets
        # How many schools to append.
        diff = desired_number_of_school_facets - resulting_schools.count
        # Find schools which are not already included in the results, which have works_count > 0.
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

  end

 def go_to_user_most_recent_work
   work = current_user.works.last
   proj = work.project
   redirect_to project_path(proj)
 end

  def show
    impressionist(@work)
    @comments = @work.comments.all
    @comment = @work.comments.find_by(params[:comment_id])
    @suggested_tags = @work.suggesteds.where(open: true)

    if current_user
      # for Gradients
      if current_user.gradients.find_by(work_id: @work.id) # if user's grad exists
        @gradient = current_user.gradients.find_by(work_id: @work.id)
      else
        @gradient = current_user.gradients.build
      end
      # for Bookmarks
      # if current_user.bookmarks.find_by(work_id: @work.id) # if user's bookmark exists
      #   @bookmark = current_user.bookmarks.find_by(work_id: @work.id)
      # else
      #   @bookmark = current_user.bookmarks.build
      # end
    end
  end

  def new
    @disable_footer = true
    @work = current_user.works.build
  end

  def new_google_upload_dan
    @disable_footer = true
    @work = current_user.works.build
  end

  # def new_multiple
  #   @work = current_user.works.build
  # end

  # def create
  #   respond_to do |format|
  #     @work = current_user.works.build(work_params.merge(school_id: current_user.school_id))
  #     if @work.save
  #       format.html {redirect_to snooty_librarian_path
  #                    flash[:info] = "Thank you! Your work was successfully added to the library." }
  #       format.js {
  #         flash[:info] = "Thank you! Your work was successfully added to the library."
  #         render :js => "window.location = '#{snooty_librarian_path}'"
  #       }
  #     else
  #       format.html { flash[:warning] = "Mission failed."
  #                     render 'new' }
  #       format.js {
  #         render :js => "window.location = '#{signin_path}'" if !logged_in?
  #         render :js => "window.location = '#{new_work_path}'" if logged_in?
  #       }
  #     end
  #   end
  # end

  def google_import

    ## HANDLE BATCHED PARAMS FROM _new_google_upload_dan.html.erb
    ### (see whiteboard/batched-params-google.txt)

    errors = []

    begin

      # for each param, create an object which will be saved by activerecord
      params[:work].each do |param| # w/r/t [{"file_name": "stuff...", "file_content_html": "<span>asdf..."}, {"file_name": "stuff..."}]

        obj = {} # reset obj

        param.collect do |key, attrib|
          obj[key] = attrib # build objects {file_name: "asdf"}'s '
        end
          # puts obj # check ups
        @w = current_user.works.build(obj)
        @w.save
      end

    # ERRORSING

    # catch errors and stick them in an array
    ## TODO: do something with them
    rescue => error
      errors.push(error.to_s)
    end

    puts 'ERRORS ==================================================='
    errors.each do |error|
      puts error
    end
    puts 'END ERRORS ==============================================='

    ## REDIRECT

    respond_to do |format|
      format.html {
        flash[:info] = "Thank you! Your work was successfully added to the library."
        redirect_to project_path(@w.project, format: :html) # snooty_librarian_path
        puts "Handled courtesy of format.html"
        # render :js => "window.location = #{project_path(@w.project).to_json}"
      }
      format.js {
        flash[:info] = "Thank you! Your work was successfully added to the library."
        render :js => "window.location = '#{project_path(@w.project)}'"
        # head project_id: @w.project.id
        puts "Handled courtesy of format.js"
      }
      format.json {
        format.json {
          head :no_content
          # redirect_to project_path(@w.project)
          puts "Handled courtesy of format.json"
        }
      }
    end

  end

  def begin_new_version
    respond_to do |format|
      work = Work.find(params[:id])
      new_work = current_user.works.build(
        project_id: work.project_id,

        file_content_html: work.file_content_html,
        file_content_md: work.file_content_md,
        file_content_text: work.file_content_text,

        school_id: work.school_id,

        name: "copy of #{work.name}",
        description: "a new version of #{work.name}",
        source_from: work.source_from,
        file_name: work.file_name,
        content_type: work.content_type
      )
      if new_work.save
        format.html {
          redirect_to project_path(work.project)
          flash[:success] = "Created <strong>#{new_work.name}</strong>".html_safe
        }
        format.js {
          flash[:success] = "Created <strong>#{new_work.name}</strong>".html_safe
          render :js => "window.location = '#{project_path(work.project)}'"
        }
      else
        format.html {
          redirect_to project_path(work.project)
          flash[:danger] = "Failed to create a new version."
        }
        format.js {
          flash[:danger] = "Failed to create a new version."
        }
      end
    end
  end

  # not in use
  def save_as_new_version
    respond_to do |format|
      @work = current_user.works.build(work_params.merge(school_id: current_user.school_primary.id)) # change params to work_params
      if @work.save
        format.html {redirect_to project_path(@work.project)
                     flash[:info] = "Saved." }
        format.js {
          flash[:info] = "Saved!"
          # render :js => "window.location = '#{project_path(@work.project)}'"
        }
      else
        format.html { flash[:warning] = "Mission failed." }
        format.js {
          flash[:info] = "Failed to save :-("
          # render :js => "window.location = '#{signin_path}'" if !logged_in?
          # render :js => "window.location = '#{new_work_path}'" if logged_in?
        }
      end
    end
  end

  def create
    respond_to do |format|
      @work = current_user.works.build(work_params.merge(school_id: current_user.school_primary.id)) # change params to work_params
      if @work.save
        format.html {redirect_to snooty_librarian_path
                     flash[:success] = "Thank you! Your work was successfully added to the library." }
        format.js {
          flash[:success] = "Awesome! Your work was successfully added to the library."
          render :js => "window.location = '#{project_path(@work.project)}'"
        }
      else
        format.html { flash[:warning] = "Mission failed."
                      render 'new' }
        format.js {
          render :js => "window.location = '#{signin_path}'" if !logged_in?
          render :js => "window.location = '#{new_work_path}'" if logged_in?
        }
      end
    end
  end

  def edit
    # @work = Work.friendly.find(params[:id])
    @comments = @work.comments.all
    session[:return_to] ||= request.referer
  end

  def update
    @work = Work.friendly.find(params[:id])
    respond_to do |format|
      if @work.update!(work_params)
        format.html { redirect_to @work
                      # render json: @work
                      flash[:success] = 'Work successfully updated!'  }
        format.json {
          render json: @work
          # flash[:success] = "Saved json!"
        }
        format.js {
          flash.now[:success] = "Saved!"
        }
      else
        format.html { render action: "edit" }
        format.json {
          render json: @work
        }
      end
    end
  end

  # http://stackoverflow.com/questions/8662250/how-do-i-create-a-temp-file-and-write-to-it-then-allow-users-to-download-it
  def download
    work = Work.friendly.find(params[:id])

    requested_type = params[:download_as]

    case requested_type
      when 'markdown'
        extension = '.md'
        file_type = "text/markdown"

      when 'plain'
        extension = '.txt'
        file_type = 'text/plain'

      when 'pdf'
        extension = '.pdf'
        file_type = 'application/pdf'

        begin
        # created converted pdf in /tmp
        file_path = "#{Rails.root}/tmp/downloads/#{download_name(work.name)}.pdf"
        PandocRuby.convert(work.file_content_md, :s, {:f => :markdown, :o => file_path})

        # send_file ("#{Rails.root}/tmp/downloads/#{basename}.pdf")
        File.open(file_path, 'r') do |f|
          send_data f.read, type: "application/pdf", :filename => "#{download_name(work.name)}.pdf"
        end

        ensure
        File.delete(file_path)
        end


      when 'open_office'
        extension = '.odt'
        file_type = 'application/vnd.oasis.opendocument.text'

      when 'microsoft_word'
        extension = '.docx'
        file_type = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'

      else
        puts "shit"
      end

      unless requested_type == 'pdf'
        send_data work.as_file(requested_type),
          :filename => "#{download_name(work.name)}#{extension}",
          :type => "#{file_type}"

      else
        # File.unlink("#{Rails.root}/tmp/downloads/#{basename}.pdf")
      end
  end

  def shelving_cart_edit
    respond_to do |format|
      if current_user
        @works = current_user.works.where(created_at: 500.minutes.ago..Time.now)
        format.html
        format.json { render json: @works }
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

  def destroy
    @work.remove_document!
    is_last = @work.project.works_count > 1 ? false : true
    puts "is last work? => #{is_last}"
    @work.save
    @work.destroy
    respond_to do |format|
      format.html { flash[:info] = "Successfully deleted the file."
                    redirect_to :back }
      format.json { head :no_content }
      format.js   {
        # render :layout => false
        render :js => "window.location = '#{projects_path}'" if is_last
        render :js => "window.location = '#{project_path(@work.project)}'" if !is_last
        flash[:success] = "<span style='color: red;'>Deleted</span> <strong>#{@work.name}</strong>"
      }
    end
  end

  def change_policy
    #@work = Work.friendly.find(params[:id])
    @work.anonymouse = !@work.anonymouse
    respond_to do |format|
      if @work.save
        format.html {
          redirect_to :back
          if @work.anonymouse
            flash[:info] = "Made #{@work.name || @work.file_name} the work of superman, aka #{@work.author_name}!"
          else
            flash[:info] = "Made #{@work.name || @work.file_name} the work of #{@work.user.name} (that's you!)"
          end
        }
        format.json { head :no_content }
        format.js {}
      else
        format.html {
          redirect_to :back
          flash[:warning] = "Failed to change the work's policy."
        }
        format.json { head :no_content }
        format.js {}
      end
    end
  end

  def recommend
    recommendation = current_user.recommendeds.find_or_initialize_by(work_id: @work.id)
    if !recommendation.created_at.nil?
      respond_to do |format|
        if recommendation.delete
            format.html {
              flash[:warning] = "Work successfully un-recommended."
              redirect_to :back #session.delete(:return_to)
            }
            format.json { head :no_content }
            format.js {}
        else
          format.html {
            flash[:warning] = "Failed to un-recommend the work."
            redirect_to :back # session.delete(:return_to)
          }
          format.json { head :no_content }
          format.js {}
        end
      end
    else
      respond_to do |format|
        if recommendation.save
          format.html {
            flash[:success] = "Work successfully recommended."
            redirect_to :back #session.delete(:return_to)
          }
          format.json { head :no_content }
          format.js {}
        else
          format.html {
            flash[:warning] = "Failed to recommend the work."
            redirect_to :back # session.delete(:return_to)
          }
          format.json { head :no_content }
            format.js {}
        end
      end
    end
  end


	private

    def set_update_callback_skip
      Work.skip_callback(:update, :after, :update_if_file_content_md_changed)
      Work.skip_callback(:update, :after, :update_if_file_content_text_changed)
    end

    def set_update_callback_skip_for_create
      Work.skip_callback(:update, :after, :update_diffs_if_any)
      Work.skip_callback(:update, :after, :save_revision)
    end

    def set_create_callback_skip
      Work.skip_callback(:save, :after, :set_name)
    end

    def set_work
      @work = Work.friendly.find(params[:id])
    end

    def weak_params
      params.require(:work).permit(:name, :file_content_html, :content_type, :source_from)
    end

	  def work_params
	  	params.require(:work).permit(:name,
                                   :user_id,
                                   :document,
                                   :remote_document_url,
                                   :created_at,
                                   :content_type,
                                   :file_name,
                                   :context_list,
                                   :content_list,
                                   :anonymouse,
                                   :description,
                                   :slug,
                                   :file_content_html,
                                   :file_content_md,
                                   :file_content_text,
                                   :source_from,
                                   :project_id,
                                   :download_as
                                   )
    end

	  def correct_user
      if
        @work = Work.friendly.find(params[:id])
        @work.user == current_user # <-- returns true if user is author of work
      else
  	    redirect_to root_url
        flash[:danger] = "That ain't yo work!"
      end
	  end

end
