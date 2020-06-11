class ApiExamplesController < ApplicationController
  before_action :load_api_example
  before_action :require_write_enabled, only: :destroy

  def curl
  end

  def destroy
    @api_example.destroy
    redirect_to details_api_action_path(api_resource: @api_example.resource,
      api_host: @api_example.host,
      api_version: @api_example.version,
      api_action: @api_example.action),
    notice: 'The API example was deleted successfully'
  end

  private
  def load_api_example
    @api_example = ApiExample.find(params[:id])
  end

end
