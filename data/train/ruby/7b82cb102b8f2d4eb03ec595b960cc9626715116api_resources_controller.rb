class ApiResourcesController < ApplicationController

  before_filter :load_common_vars, :add_common_breadcrumbs

  def index
    @api_resources = @api_version.api_resources

    add_breadcrumb @api_version.name + ' Resources'
  end

  def show
    @api_resource = ApiResource.new(name: params[:id], api_version: @api_version)
    @api_actions = @api_resource.api_actions

    add_breadcrumb @api_version.name + ' Resources', api_resources_path(api_host: @api_host.name, api_version: @api_version.name)
    add_breadcrumb @api_resource.name
  end

  private
  def load_common_vars
    @api_host = ApiHost.new(name: params[:api_host])
    @api_version = ApiVersion.new(name: params[:api_version], api_host: @api_host)
  end

  def add_common_breadcrumbs
    add_breadcrumb @api_host.name + " Versions", api_versions_path(api_host: @api_host.name)
  end
end
