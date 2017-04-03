require 'lazy_high_charts'
require 'json'
# require 'wikipedia' # per gem 'wikipedia-client'

class SchoolsController < ApplicationController
	include ApplicationHelper
	include SchoolsHelper
	# before_action :logged_in_user, only: [:index, :show]
	respond_to :html, :js, :json
	# layout Proc.new{ '../views/schools/show2' if ['show'].include?(action_name) }


	def index

		# Disallow esoteric technical and beauty schools.
		@show_me_the_beauty_schools = false

		# # Solr search method.
    # @searchschools = School.search do
    # 	fulltext params[:searchschools]
    # 	order_by(:works_count, :desc)
    # 	# order_by(:projects_count, :desc)
    # 	order_by(:affiliations_count, :desc)
    # 	order_by(:Institution_Name, :asc)
    # 	facet :Institution_City
    # 	with(:is_academic, true)
    # 	# with(:Accreditation_Date_Type, "Actual")
    # 	paginate(:page => params[:page] || 1, :per_page => 15)
    # end
    # @schools = @searchschools.results

    if params[:searchschools].present?
      @schools = School.search(query: params[:searchschools].present? ? params[:searchschools] : nil )
                 .paginate(
                   page: params[:page] || 1,
                   per_page: params[:searchschools].present? ? 25 : 15 # show more results if searching
                 )
      @results_count = @schools.count
    else
      @schools = School.where.not(logo: nil, affiliations_count: 0)
              .order(works_count: :desc)
              .order(affiliations_count: :desc)
              .order(Institution_Name: :asc)
              .first(25)
    end

    # Override template for prototyping the new schools table.
    render :template => 'schools/index_table'





		######################################
		##### This for use with Kaminari and AngularJS paging directive.
		######################################
    # @schools = School.page(params[:page]).per(50)
    # respond_to do |format|
    #   format.html { }
    #   format.json { render json: @schools, meta: {
    #     number_of_pages: @schools.num_pages,
    #     current_page: @schools.current_page,
    #     total_count: @schools.total_count
    #     }
    #   }
    # end

    ######################################
    ##### This works with the state map java script -- useful for works/index too?!
    ##### note specifically the interpolated state params attribute (passed from Angular)
    ######################################
    # @schools = School.where(Institution_State: "#{params[:state]}".upcase)
    # respond_to do |format|
    #   format.html { }
    #   format.json { render json: @schools, meta: {
    #     # number_of_pages: @schools.num_pages,
    #     # current_page: @schools.current_page,
    #     # total_count: @schools.total_count
    #     }
    #   }
    # end
	end

	def show

		@school = School.friendly.find(params[:id])
		@users = @school.users.order("works_count desc").first(24)
    @projects = Project
                .includes([:school, :user])
                .search(id: params[:project_id],
                               query: params[:search].present? ? params[:search] : nil,
                               school_id: @school.id
                              )
                .paginate(
                               page: params[:page] || 1,
                               per_page: 12
                )
    # @total_results = @projects.count

		if !@school.wikipedia_coords.nil?
			@school_coords_lat = JSON.parse(@school.wikipedia_coords)[0]
			@school_coords_lng = JSON.parse(@school.wikipedia_coords)[1]
		elsif !@school.geocode_json.nil?
			@school_coords_lat = @school.geocode_lat
			@school_coords_lng = @school.geocode_lng
		else
			# TODO: FIXME
			@school_coords_lat = 0.1
			@school_coords_lng = 0.1
		end


		# I'm going to move all of this to a static one-time-run rake task.
		# The problem is for under-the-radar schools, the request is hanging and
		# causing our http request to last for hours, which eventually overloads the
		# passenger qeue.
		# page = Wikipedia.find(@school.Institution_Name.gsub('-', ' '))

		# if !page.text.nil?
		# 	@wiki_summary = page.summary
		# 	@wiki_url = page.fullurl
		# else
		# 	@wiki_summary = 'No summary available.'
		# end
		# @wiki = {}
		# @wiki['summary'] = page.summary
		# @wiki['fullurl'] = page.fullurl
		# @wiki['templates'] = page.templates
		# if page.text.present?
		# 	@wiki_summary = page.summary
		# 	@wiki_url = page.fullurl
		# 	@wiki_images = page.image_urls
		# else
		# 	@wiki_summary = 'There was no page.'
		# 	@wiki_url = 'There was no page.'
		# 	@wiki_images = ['There was no page.']
		# end

	end

	######################################
	##### This for use in creating school_domain_slice. (See scratch from early Feb.)
	######################################
	##### Prefixes.
	# def REMOVE_WWW_REGEX
	# 	abc = "/(www.|http://|https://|ssh://)/g"
	# 	@REMOVE_WWW_REGEX = abc.to_s
	# end
	##### Suffixes, ie. "/some/where/else.html" from any domain
	# \b((?:\/+)[a-z0-9\.\?\=\_\-]{0,})

	######################################
	##### This for use in importing gov't-derived schools csv table.
	######################################
	# def import
	# 	School.import(params[:file])
	# end

private

	def school_params
		params.require(:school).permit(
			:Institution_ID,
			:Institution_Name,
			:Institution_Address,
			:Institution_City,
			:Institution_State,
			:Institution_Zip,
			:Institution_Phone,
			:Institution_OPEID,
			:Institution_IPEDS_UnitID,
			:Institution_Web_Address,
			:Accreditation_Type,
			:Agency_Name,
			:Agency_Status,
			:Program_Name,
			:Accreditation_Status,
			:Accreditation_Date_Type,
			:Periods,
			:Last_Action,
			:school_domain_slice,
			:remote_favicon_url)
	end

end
