class ApiKeysController < ApplicationController
  def index
    @api_keys = ApiKey.all
  end

  def show
    @api_key = ApiKey.find(params[:id])
  end

  def new
    @api_key = ApiKey.new
  end

  def create
    @api_key = ApiKey.new(params[:api_key])
    if @api_key.save
      redirect_to @api_key, :notice => "Successfully created api key."
    else
      render :action => 'new'
    end
  end

  def edit
    @api_key = ApiKey.find(params[:id])
  end

  def update
    @api_key = ApiKey.find(params[:id])
    if @api_key.update_attributes(params[:api_key])
      redirect_to @api_key, :notice  => "Successfully updated api key."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @api_key = ApiKey.find(params[:id])
    @api_key.destroy
    redirect_to api_keys_url, :notice => "Successfully destroyed api key."
  end
end
