module Turbot
  module Helpers
    extend self

    # Returns a Turbot API client.
    #
    # @param [String] api_key an API key
    # @return [Turbot::API] a Turbot API client
    def api(api_key = nil)
      # For whatever reason, unless we provide a truthy API key, Turbot::API's
      # initializer immediately attempts to `#get_api_key_for_credentials`.
      api_key ||= email_address_and_api_key[1] || ''
      turbot_api.new(turbot_api_parameters.merge(:api_key => api_key))
    end

    # Returns the parameters for the Turbot API, based on the base URL of the
    # Turbot server.
    #
    # @return [Hash] the parameters for the Turbot API
    def turbot_api_parameters
      uri = URI.parse(host)

      {
        :host => uri.host,
        :port => uri.port,
        :scheme => uri.scheme,
      }
    end

    # The `turbot_api` gem is slow to load, so we defer its loading.
    #
    # @return [Class] the Turbot::API class
    def turbot_api
      @turbot_api ||= begin
        require 'turbot_api'

        Turbot::API
      end
    end
  end
end
