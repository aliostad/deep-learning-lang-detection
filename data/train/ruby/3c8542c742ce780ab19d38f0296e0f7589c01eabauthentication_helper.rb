module AuthenticationHelper
  PUBLIC_ROUTES = {
    'POST' => [
      '/api/users',
      '/api/authenticate'
    ]
  }

  def authenticate_user
    if api_token.blank?
      json_error("API token required", 401)
    end

    @api_user = User.find_by_api_token(api_token)

    if @api_user.nil?
      json_error("Invalid API token", 401)
    end
  end

  def api_token
    @api_token ||= request.env['HTTP_X_API_TOKEN'] || params[:api_token]
  end

  def require_authentication?
    route = PUBLIC_ROUTES[request.request_method] || []
    !route.include?(request.path)
  end
end