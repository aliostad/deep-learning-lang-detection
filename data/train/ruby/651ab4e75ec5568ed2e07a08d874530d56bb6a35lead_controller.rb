class LeadController < ApplicationController
  before_action :set_lead, only: [:show, :edit, :update, :destroy]
  
  def index
    @api_config = ApiConfig.find(params[:api_config_id])
    attrs = {
      :username => @api_config.username,
      :password => @api_config.password,
      :security_token => @api_config.security_token,
      :client_id => @api_config.client_id,
      :client_secret => @api_config.client_secret
     }
    @leads = RdApi::Lead.new(attrs).all
  end

  def new
    @api_config = ApiConfig.find(params[:api_config_id])
  end

  def create
    @api_config = ApiConfig.find(params[:api_config_id])
    attrs = {
      :username => @api_config.username,
      :password => @api_config.password,
      :security_token => @api_config.security_token,
      :client_id => @api_config.client_id,
      :client_secret => @api_config.client_secret
     }
    @new_id = RdApi::Lead.new(attrs).create(lead_params[:Title], lead_params[:Phone], lead_params[:Company], lead_params[:Email], lead_params[:FirstName], lead_params[:LastName])
    flash[:notice] = 'Lead helper was successfully created.'
	redirect_to api_config_lead_path(@api_config, @new_id)
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      @api_config = ApiConfig.find(params[:api_config_id])
      attrs = {
        :username => @api_config.username,
        :password => @api_config.password,
        :security_token => @api_config.security_token,
        :client_id => @api_config.client_id,
        :client_secret => @api_config.client_secret
       }
      @lead = RdApi::Lead.new(attrs).find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lead_params
      params.permit(:api_config_id, :Title, :Phone, :Company, :Email, :FirstName, :LastName, :utf8, :authenticity_token, :commit)
    end
end
