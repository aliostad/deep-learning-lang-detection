class ApiClientsController < ApplicationController
  before_action :check_if_administrator

  def index
    @api_clients = ApiClient.all
  end

  def new
    @api_client = ApiClient.new(enabled: true)
  end

  def create
    @api_client = ApiClient.new(permitted_params)
    @api_client.save

    respond_to do |format|
      format.js do
        render partial: 'shared/error_messages', locals: {
          object: @api_client, target_path: api_clients_path
        }
      end
    end
  end

  def edit
    @api_client = ApiClient.find(params[:id])
  end

  def update
    @api_client = ApiClient.find(params[:id])
    @api_client.update_attributes(permitted_params)

    respond_to do |format|
      format.js do
        render partial: 'shared/error_messages', locals: {
          object: @api_client, target_path: api_clients_path
        }
      end
    end
  end

  def destroy
    @api_client = ApiClient.find(params[:id])
    @api_client.destroy

    redirect_to api_clients_path
  end

  protected

  def permitted_params
    params[:api_client].permit(:name, :enabled, :observations)
  end
end
