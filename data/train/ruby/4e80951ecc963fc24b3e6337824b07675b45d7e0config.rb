module WHMCS
  # WHMCS::Config stores configuration data for connecting to the WHMCS API
  class Config
    # The WHMCS API username
    attr_accessor :api_username

    # The WHMCS API password
    attr_accessor :api_password

    # The WHMCS API URL
    attr_accessor :api_url
    
    # To be able to bypass SSL cert verification
    attr_accessor :verify_ssl

    # Create a new config object
    def initialize
      @api_username = 'example_api_user'
      @api_password = 'example_api_pass'
      @api_url      = 'http://example.com/api.php'
      @verify_ssl   = true
    end
  end
end
