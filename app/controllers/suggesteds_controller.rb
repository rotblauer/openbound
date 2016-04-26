class SuggestedsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :confirm, :deny]
  before_action :correct_user, only: [:confirm, :deny]
  respond_to :json, :html, :js

  def new
    @suggestion = @work.suggesteds.new
    render partial: "suggesteds/new"
  end

  # Note: suggestions can be created as "red, blue, yellow", though, on approval said example will become three separate tags (via #confirm..parse: true).
  def create

    ### This one works. 
    # @work = Work.friendly.find(params[:work_id])
    # @suggestion = @work.suggesteds.build(suggestion_params)
    # @suggestion.suggester_ip = request.remote_ip
    # @suggestion.user = current_user if current_user
    # respond_to do |format|
    #   if @suggestion.save
    #     format.html { redirect_to @work
    #                   flash[:success] = "Your tag suggestion has been added!" }
    #     format.json { render json: @suggestion, status: :created, location: @suggestion } 
    #   else
    #     format.html { redirect_to @work
    #                   flash[:warning] = "Suggesting the suggestion failed. Probably either because you had weird characters in there, or the suggestion exists already." }
    #     format.json { render json: @suggestion.errors, status: :unprocessable_entity }
    #   end
    # end

    # This one parses the incoming suggestion(s). AND IT WORKS TOO. 
    @work = Work.friendly.find(params[:work_id])
    suggestions = params[:suggested][:suggestion].split(',')
    @i = 0
    if current_user
      @current_user_id = current_user.id 
    else 
      @current_user_id = nil 
    end

    suggestions.each do |s, index|
      new_suggestion = @work.suggesteds.build(
        suggester_ip: request.remote_ip,
        user_id: @current_user_id,
        suggestion: s)
      if new_suggestion.save
        @i += 1
      end 
      if @i == suggestions.count
        @suggestions_saved = true
      else 
        @suggestions_saved = false
      end
    end
    respond_to do |format|
      if @suggestions_saved
        format.html { redirect_to @work 
                      flash[:info] = "Success."}
        format.json { }
      else
        format.html { redirect_to @work 
                      flash[:danger] = "Suggested tags must be unique."}
        format.json { }
      end
    end 
  end

  def confirm_context
    @suggested = Suggested.find(params[:id])
    @work = @suggested.work 
    @work.context_list.add("#{@suggested.suggestion}", parse: true)
    respond_to do |format|
      if @work.save && @suggested.update(approved: true, open: false)
        format.html { redirect_to :back
                      flash[:info] = "Tag on context added!" }
        format.js {}
      else
        format.html { redirect_to :back
                      flash[:warning] = "Houston, we have a problemo." }
        format.js {}
      end
    end
  end
  def confirm_content
    @suggested = Suggested.find(params[:id])
    @work = @suggested.work 
    @work.content_list.add("#{@suggested.suggestion}", parse: true)
    respond_to do |format|
      if @work.save && @suggested.update(approved: true, open: false)
        format.html { redirect_to :back
                      flash[:info] = "Tag on content added!" }
        format.js {}
      else
        format.html { redirect_to :back
                      flash[:warning] = "Houston, we have a problemo." }
        format.js {}
      end
    end
  end

  def deny
    @suggested = Suggested.find(params[:id])
    respond_to do |format|
      if @suggested.update(approved: false, open: false)
        format.html { redirect_to :back
                      flash[:info] = "Not in dis house! (Suggestion successfully denied.)" }
        format.js {}
      else
        format.html { redirect_to :back
                      flash[:warning] = "Problemo!!" }
        format.js {}
      end
    end
  end

  private

    def suggestion_params
      params.require(:suggested).permit(:suggestion)
    end

    def correct_user
      if current_user
        @suggested = Suggested.find(params[:id])
        @suggested.author_id == current_user.id
      end
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to signin_url
      end
    end

end
