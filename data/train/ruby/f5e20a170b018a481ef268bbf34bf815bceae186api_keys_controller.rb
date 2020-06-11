class ApiKeysController < ApplicationController
  before_filter :authenticate_user!

  def index
    @api_keys = ApiKey.all
  end

  def new
    @api_key = ApiKey.new
  end

  def destroy
    @api_key = ApiKey.find(params[:id])
    @api_key.destroy

    redirect_to action: 'index'
  end

  def create
    @api_key = ApiKey.new(api_key_params)
    if @api_key.save
      redirect_to action: 'index'
    else
      render 'new'
    end
  end

  private
    def api_key_params
      params.require(:api_key).permit(:description)
    end
end
