class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :destroy]
  before_action :correct_user, only: [:edit, :destroy]
  before_filter :set_work

  def index
  end
 
  def new
    @comment = @work.comments.new
    render partial: "comments/new"
  end
 
  def create
    @comment = @work.comments.new(comment_params.merge(project_id: @work.project.id))
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @work.project
                      flash[:info] = 'Comment successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to :back
                    flash[:info] = 'Comment successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_work
      @work = Work.friendly.find(params[:work_id])
    end

    def comment_params
      params.require(:comment).permit(:user_id, :work_id, :project_id, :body)
    end

    def correct_user
      @comment = Comment.find(params[:id])
      current_user = @comment.user
    end

end