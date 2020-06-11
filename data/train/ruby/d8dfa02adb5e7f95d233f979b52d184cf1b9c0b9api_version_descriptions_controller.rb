class ApiVersionDescriptionsController < ApplicationController
  before_action :require_write_enabled

  def create
    api_version_description = ApiVersionDescription.new(descriptions_params)
    api_version_description.save!
    @description = api_version_description.description
    render 'show'
  end

  def update
    api_version_description = ApiVersionDescription.find(params[:id])
    api_version_description.description = descriptions_params[:description]
    api_version_description.save!
    @description = api_version_description.description
    render 'show'
  end

  def preview
    @description = params[:description]
  end

  def destroy
    api_version_description = ApiVersionDescription.find(params[:id])
    api_version_description.destroy
    redirect_to api_resources_path(api_host: api_version_description.api_host,
      api_version: api_version_description.api_version)
  end

  private
  def descriptions_params
    params.require(:api_version_description).permit(:api_host, :api_version, :description)
  end
end
