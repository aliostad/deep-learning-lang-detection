require "ibssm_api_client/version"
require "rails"
require "ibssm_api_client/ibssm_api_railtie"
require "ibssm_api_client/base"
require "ibssm_api_client/authenticate"
require "ibssm_api_client/response_handler"
require "ibssm_api_client/comment"
require "ibssm_api_client/homework"
require "ibssm_api_client/payment"
require "ibssm_api_client/role"
require "ibssm_api_client/search"
require "ibssm_api_client/stat"
require "ibssm_api_client/user"
require "ibssm_api_client/exceptions/ibssm_api_connection_error"
require "ibssm_api_client/exceptions/ibssm_api_error"
require "ibssm_api_client/exceptions/ibssm_api_syntax_error"
require "ibssm_api_client/exceptions/ibssm_authentication_error"
require "ibssm_api_client/exceptions/ibssm_resource_not_found_error"


module IbssmApiClient
  
  mattr_accessor :base_url
  mattr_accessor :debug
  mattr_accessor :username
  mattr_accessor :password
  mattr_accessor :logger
  mattr_accessor :auth_token
  
end


