class ApiActionsController < ApplicationController
  def details
    @api_host = ApiHost.new(name: params[:api_host])
    @api_version = ApiVersion.new(name: params[:api_version], api_host: @api_host)
    @api_resource = ApiResource.new(name: params[:api_resource], api_version: @api_version)
    @api_action = ApiAction.new(name: params[:api_action], api_resource: @api_resource)

    add_breadcrumb @api_host.name + " Versions", api_versions_path(api_host: @api_host.name)
    add_breadcrumb @api_version.name + ' Resources', api_resources_path(api_host: @api_host.name, api_version: @api_version.name)
    add_breadcrumb @api_resource.name, api_resource_path(@api_resource.name, api_host: @api_host.name, api_version: @api_version.name)
    add_breadcrumb @api_action.name
  end

end
