class ApisController < ApplicationController

  def new
    @api = Api.new
    @api.mappings.build
  end

  def index
    @apis = Api.all
  end

  def create
    @api = Api.new(api_params)

    if @api.save
      redirect_to api_url(@api)
    else
      render :new
    end
  end

  def show
    @api = Api.find(params[:id])
  end

  def call
    @results = Api.query(params[:id], params[:q])

    respond_to do |format|
      format.json do
        render json: @results
      end
    end
  end

  private

  def api_params
    params.require(:api).permit!
  end

end
