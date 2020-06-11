module Diffbot

  # Configuration options for {Diffbot}
  module Configurable

    # Default API endpoint
    DEFAULT_API_ENDPOINT = "http://api.diffbot.com"

    # Default API version
    DEFAULT_API_VERSION = "v2"

    # @!attribute api_endpoint
    #   @return [String] Base URL for API requests. default: http://api.diffbot.com
    # @!attribute api_version
    #   @return [String] Base URL for API requests. default: 2
    # @!attribute token
    #   @return [String] Access token for API requests.
    attr_accessor :api_endpoint, :api_version, :token

    # Set configurable options using a block
    def configure
      yield self
    end

    # Set configuration options to default values
    def setup!
      instance_variable_set(:@api_endpoint, DEFAULT_API_ENDPOINT)
      instance_variable_set(:@api_version, DEFAULT_API_VERSION)
    end
  end
end
