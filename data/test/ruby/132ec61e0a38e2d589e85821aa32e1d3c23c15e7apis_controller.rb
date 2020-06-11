class ApisController < ApplicationController
  load_and_authorize_resource except: :create
  
  def index
    @apis = Api.order("created_at DESC").page(params[:page]).per(10)
  end

  def new
    @api = Api.new
  end

  def create
    Rails.logger.info "Creating API"
    
    api = Api.new api_params
    api.user_id = current_user.id
    authorize! :create, api

    if api.save!
      redirect_to api, notice: "Successfully created an API"
    else
      flash.now.alert = "Error adding API"
      render "new"
    end
  end

  def edit
    if params[:id] && @api = Api.find_by_id(params[:id])
      @api
    else
      redirect_to "/404.html"
    end
  end

  def update
    Rails.logger.info "Updating API"
    if params[:id] && @api = Api.find_by_id(params[:id])
      api = Api.find_by_id(params[:id])
      if api.update_attributes!(api_params)
        flash.notice = "Successfully updated API"
      else
        flash.alert = "Error updating API"
      end

      redirect_to api
    else
      redirect_to "/404.html"
    end
  end

  def show
    Rails.logger.info "Showing API"
    if params[:id] && @api = Api.find_by_id(params[:id])
      Rails.logger.info params[:id] + " - " + @api.inspect
      @api
    else
      redirect_to "/404.html"
    end
  end

  def destroy
    Rails.logger.info "Deleting API"
    if params[:id] && @api = Api.find_by_id(params[:id])
      if @api.destroy
        redirect_to apis_url, notice: "Successfully deleted API"
      else
        redirect_to @api, "Error deleting API"
      end
    else
      redirect_to "/404.html"
    end
  end

  private
    def api_params
      params.required(:api).permit(:name, :path, :docs)
    end
end
