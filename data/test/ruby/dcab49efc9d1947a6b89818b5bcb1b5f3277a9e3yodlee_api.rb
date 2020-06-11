require "yodlee_api/version"
require "yodlee_api/config"
require "yodlee_api/cobrand_credentials"
require "yodlee_api/cobrand_login"
require "yodlee_api/user_registration"
require "yodlee_api/credentials"
require "yodlee_api/content_services"
require "yodlee_api/item_management"
require "yodlee_api/user_login"
require "yodlee_api/refresh_service"
require "yodlee_api/data_service"
require "yodlee_api/transaction_search"
require "yodlee_api/transaction_search_request"

module YodleeApi
  extend Config

    # Yields this module to a given block. Please refer to the YodleeApi::Config module for configuration options.
    def self.configure
      yield self if block_given?
    end
  
end




