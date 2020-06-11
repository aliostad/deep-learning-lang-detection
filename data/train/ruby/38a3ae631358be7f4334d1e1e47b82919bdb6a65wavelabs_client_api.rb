require "wavelabs_client_api/version"

require "wavelabs_client_api/client/api/core/base_api"
require "wavelabs_client_api/client/api/core/auth_api"
require "wavelabs_client_api/client/api/core/users_api"
require "wavelabs_client_api/client/api/core/media_api"
require "wavelabs_client_api/client/api/core/social_api"


require "wavelabs_client_api/client/api/data_models/base_api_model"
require "wavelabs_client_api/client/api/data_models/login_api_model"
require "wavelabs_client_api/client/api/data_models/media_api_model"
require "wavelabs_client_api/client/api/data_models/member_api_model"
require "wavelabs_client_api/client/api/data_models/message_api_model"
require "wavelabs_client_api/client/api/data_models/social_accounts_api_model"
require "wavelabs_client_api/client/api/data_models/token_api_model"
require "wavelabs_client_api/client/api/data_models/token_details_api_model"

module WavelabsClientApi

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_host_url, :client_key, :client_secret
  end

end
