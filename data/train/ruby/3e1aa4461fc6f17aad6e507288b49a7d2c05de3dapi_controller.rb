class ApiController < ApplicationController

  ## GET : '/api/keys'
  def keys
    @keys = ApiKey.all.order("created_at desc")
    respond_to :html
  end

  ## POST : '/api/keys/create'
  def create
    api_key = ApiKey.create(name: params[:name])
    flash[:alert] = api_key.errors if api_key.errors.count > 0
    redirect_to controller: "api", action: "keys"
  end

  ## POST : '/api/keys/destroy'
  def destroy
    ApiKey.destroy(params[:id])
    redirect_to controller: "api", action: "keys"
  end

  ## GET : '/api/docs'
  def docs
  end

end