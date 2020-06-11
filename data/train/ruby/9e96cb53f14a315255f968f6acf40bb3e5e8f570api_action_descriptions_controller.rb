class ApiActionDescriptionsController < ApplicationController
  before_action :require_write_enabled

  def create
    api_action_description = ApiActionDescription.new(descriptions_params)
    api_action_description.save!
    @description = api_action_description.description
    render 'show'
  end

  def update
    api_action_description = ApiActionDescription.find(params[:id])
    api_action_description.description = descriptions_params[:description]
    api_action_description.save!
    @description = api_action_description.description
    render 'show'
  end

  def preview
    @description = params[:description]
  end

  def destroy
    api_action_description = ApiActionDescription.find(params[:id])
    api_action_description.destroy
    redirect_to details_api_action_path(api_host: api_action_description.api_host,
      api_version: api_action_description.api_version,
      api_resource: api_action_description.api_resource,
      api_action: api_action_description.api_action)
  end

  private
  def descriptions_params
    params.require(:api_action_description).permit( :api_host, :api_version, :api_resource, :api_action, :description)
  end
end
