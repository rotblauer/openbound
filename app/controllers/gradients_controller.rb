class GradientsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit]
  before_filter :set_work
  # after_action :update_work
  respond_to :json, :html, :js 

  def create
    @gradient = @work.gradients.new(gradient_params)
    @gradient.user = current_user
    @gradient.work_id = @work.id
    
    respond_to do |format|
      if @gradient.save
        format.html { redirect_to @work
                      flash[:success] = 'Gradient success!' }
        format.json { render json: @gradient, status: :created, location: @gradient }
        format.js {}
      else
        format.html { render action: "new" }
        format.json { render json: @gradient.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  def update
    @gradient = Gradient.find(params[:id]) # requires fewer http calls than the one below I think

    respond_to do |format|
      if @gradient.update(gradient_params)
        format.html { redirect_to @work 
                      flash[:info] = 'Gradient updated!' }
        format.json { render json: @gradient, status: :created, location: @gradient }
        format.js {}
      else
        format.html { render action: "new" }
        format.json { render json: @gradient.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # def update_work
  #   @gradients = @work.gradients
  #   @work.gradient_average = @gradients.average(:grad)
  #   @work.gradient_average_rgb = @work.gradient_average.round
  #   @work.gradient_count = @gradients.count
  #   @work.save
  # end

  private
  
    def set_work
      @work = Work.friendly.find(params[:work_id])
    end

    def gradient_params
      params.require(:gradient).permit(:grad)
    end

end