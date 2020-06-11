class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  def api_client
    if not @api_client
      @api_client = Google::APIClient.new
      @api_client.authorization.access_token = session[:token]
    end
    @api_client
  end
  def api_service
    @api_service ||= api_client.discovered_api('calendar', 'v3')
  end
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :api_client
  helper_method :api_service
  helper_method :current_user
end
