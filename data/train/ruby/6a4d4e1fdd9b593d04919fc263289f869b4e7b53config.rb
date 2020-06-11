module WHMCS
  # WHMCS::Config stores configuration data for connecting to the WHMCS API
  class Config
    # The WHMCS API username
    attr_accessor :api_username

    # The WHMCS API password
    attr_accessor :api_password

    # The WHMCS API URL
    attr_accessor :api_url

    # The WHMCS API Access Key
    attr_accessor :api_key

    # Create a new config object
    def initialize
      @api_username = 'Admin'
      @api_password = 'demo-in-md5'
      @api_url      = 'http://demo.whmcs.com/includes/api.php'
      @api_key      = 'whmcsdemo'
    end
  end
end
