class IndexController < ApplicationController
  before_action :disabled_on_start_page, only: [:start]
  respond_to :json, :html, :js
  include ApplicationHelper

  def start

    # Format no container. 
    @container_fluid = true
    @on_start_page = true
    disable_base_upload_forms

    # Load works previews for different screen sizes. 
    # @four_works = Work.first(4)
    # @six_works = Work.first(6)
    # @eight_works = Work.first(8)
    # @twelve_works = Work.first(12)

    # Load top schools.
    ## Use is_academic for loading only relevant schools when there are fewer than 20 schools with works added. 
    ## Then inherit default scope from schools which seems pretty damn random. 
    @top_schools = School.where(is_academic: true).where('works_count > ?', 0).order("works_count DESC").order('affiliations_count desc').first(40)

    # The limelight. 
    @featured_user = User.all.sample
    
    # Load and sort tags by most used per context. 
    #
    ## Build hash. key => tag on context, value => tag.taggings.count
    projects_context_tags_with_count = Hash.new
      Project.tag_counts_on(:contexts).each do |tag|
        projects_context_tags_with_count["#{tag.name}"] = tag.taggings.count
      end
    ## Reverse makes desc
    @context_tags = projects_context_tags_with_count.sort_by {|k,v| v}.reverse

    ## Build hash. key => tag on content, value => tag.taggings.count
    projects_content_tags_with_count = Hash.new
      Project.tag_counts_on(:contents).each do |tag|
        projects_content_tags_with_count["#{tag.name}"] = tag.taggings.count
      end
    ## Reverse makes desc
    @content_tags = projects_content_tags_with_count.sort_by {|k,v| v}.reverse

  end

  def dash_test
    @a = "thing"
  end

  def learn
    @no_container = true
  end

  # Footer directory
  def privacy
  end

  def terms_and_conditions
  end

  def team
  end

  def contact_us
  end

  # PR pages (via footer or start)
  def test
    @disable_footer = true
    @disable_please_sign_up = true
  end

  def colbysucks
    @work = Work.friendly.find('da41153e-880b-41b6-9b25-a663725c5d48')
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
      if current_user.bookmarks.find_by(work_id: @work.id) # if user's bookmark exists
        @bookmark = current_user.bookmarks.find_by(work_id: @work.id)
      else
        @bookmark = current_user.bookmarks.build
      end
    end
    render 'works/show'
  end

  # def scholarships
  # end

  # def faq
  # end

  # General receiver for all 'login'/'signup'/'signin' paths (see routes)
  def signin
    @disable_please_sign_up = true
    @user = User.new
    respond_to do |format|
      format.js {      
        render :js => "window.location = '#{signin_path}'" if !logged_in?
        render :js => "window.location = '#{new_work_path}'" if logged_in?
      }
      format.html {
        render 'index/signin'
      }
    end
  end
  
end
