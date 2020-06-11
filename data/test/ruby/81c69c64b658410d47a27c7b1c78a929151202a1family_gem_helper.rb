module FamilyGemHelper
  private
  def get_authorize_url
    initialize_api
    @client_api.authorize_url
  end

  def get_redirect_uri
    @client_api.redirect_uri
  end

  def get_token code
    initialize_api
    @client_api.get_token code
  end

  def delete_token access_token
    initialize_api
    @client_api.delete_token access_token
  end

  def get_dev_key
    initialize_api
    @client_api.dev_key
  end

  def get_current_user access_token
    initialize_api
    @client_api.get_current_user access_token
  end

  def initialize_api
    @client_api ||= FamilyConnect::Client.new(FAMILY_SEARCH_INITIALIZER)
    if(session[:access_token] && @client_api.access_token != session[:access_token])
      @client_api.access_token = session[:access_token]
    end
  end

end