require 'api/authentication'
require 'api/configurable'
require 'api/connection'

require 'idbus_api/errors'
require 'idbus_api/endpoint/stops'
require 'idbus_api/endpoint/fares'

module IdbusApi

  # Client for the iDBUS API
  #
  # @see https://api.idbus.com
  class Client < Api::Client

    # Include API gem modules
    include Api::Authentication
    include Api::Configurable
    include Api::Connection

    # Describe API endpoints
    include IdbusApi::Endpoint::Stops
    include IdbusApi::Endpoint::Fares

     # Header keys that can be passed in options hash to {#get}
    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

  end
end
