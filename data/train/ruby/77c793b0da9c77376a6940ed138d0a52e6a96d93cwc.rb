require 'cwc/utils/url'

module Cwc
  class << self
    # Includes
    include Cwc::Utils::URL

    # Attributes
    attr_accessor :api_key, :api_base
    attr_reader :api_version, :api_version_number

    # Default configuration
    @@configuration = {
      api_version_number: "2.0",
      api_version: "v2",
      api_base: "https://test-cwc.house.gov/"
    }

    def configuration
      @@configuration
    end

    # Set and Get for configuration
    def set property, value
      @@configuration[property] = value
    end

    def get property
      @@configuration[property]
    end

    # api_key
    def api_key
      self.get :api_key
    end

    def api_key= value
      self.set :api_key, value
    end

    # api_base
    def api_base
      self.get :api_base
    end

    def api_base= value
      # Add trailing slash if it's missing
      add_trailing_slash value
      self.set :api_base, value
    end

    def api_base_as_uri
      URI(self.api_base)
    end

    # api_version
    def api_version
      self.get :api_version
    end

    # api_version_number
    def api_version_number
      self.get :api_version_number
    end

    # Get a URL from the API base
    def api_url url=''
      validate_settings
      self.api_base + url
    end

    def validate_settings
      # Validate API Key
      unless self.api_key
        raise AuthenticationError.new('No API key provided. Set your API key using "Cwc.api_key = <API-KEY>"')
      end
      # Validate API base
      unless self.api_base
        raise SettingsError.new('No API base provided. Set your API base using "Cwc.api_base = <API-BASE>"')
      end
      # Validate API version
      unless self.api_version
        raise SettingsError.new('No API version provided. Set your API base using "Cwc.api_version = <API-VERSION>"')
      end
    end

    # Test function
    def test_settings verbose = true
      self.api_key = "ABC123"
      self.api_base = "http://localhost:4567"
      if verbose
        puts "API Key: "          + self.api_key
        puts "API Version: "      + self.api_version
        puts "API Base: "         + self.api_base
        puts "API URL example: "  + self.api_url(self.api_version+"/message")
      end
      true
    end
  end
end