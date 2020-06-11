module Zara4::API::Communication
  class Config
    
    USER_AGENT = 'Zara 4 RUBY-SDK, Version-' + Zara4::API::VERSION
    
    PRODUCTION_API_ENDPOINT = 'https://api.zara4.com'
    DEVELOPMENT_API_ENDPOINT = 'http://api.zara4.dev'
    
    @@BASE_URL = PRODUCTION_API_ENDPOINT
    
    
    #
    # Get the base url of the API endpoint.
    #
    def self.api_endpoint_url
      return @@BASE_URL
    end
    
    
    #
    # Configure production mode.
    #
    def self.enter_production_mode
      @@BASE_URL = PRODUCTION_API_ENDPOINT
    end
    
    
    #
    # Configure development mode.
    #
    def self.enter_development_mode
      @@BASE_URL = DEVELOPMENT_API_ENDPOINT
    end
    
    
  end
end