# AuthorizationHelper
#
# use in api tests:
#
# e.g.
#
# include AuthorizationHelper
#
# setup { add_auth_token_to_header }
#
#
module ApiAuthTestHelper
  def add_auth_token_to_header(token = api_token)
    @request.headers['Authorization'] = token
    @request.headers['Accept']        = "application/json; version=#{api_version}"
  end

  def api_version
    @api_version ||= api_config['version'] || 1
  end

  def api_token
    @api_token ||= api_config['token']
  end

  def api_config
    @api_config ||= ::Rails.application.config_for(:api)
  end
end
