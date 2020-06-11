module Shiphawk
  class Client

    PRODUCTION_API_HOST = 'https://shiphawk.com'
    SANDBOX_API_HOST = 'https://sandbox.shiphawk.com'
    DEFAULT_API_VERSION = 'v3'

    include Shiphawk::Helpers::Request
    include Shiphawk::Api::QueryHelpers
    include Shiphawk::Api::Items
    include Shiphawk::Api::Rates
    include Shiphawk::Api::ShipmentNotes
    include Shiphawk::Api::ShipmentTracking
    include Shiphawk::Api::Shipments
    include Shiphawk::Api::ShipmentsStatus
    include Shiphawk::Api::ZipCodes
    include Shiphawk::Api::Notifications

    attr_reader :api_token, :options, :sandbox

    def initialize(options={api_token: Shiphawk.api_token})
      host = Shiphawk.sandbox ? SANDBOX_API_HOST : PRODUCTION_API_HOST
      @options = options
      @api_token = @options.delete(:api_token) { |key| Shiphawk.api_token }
      @api_version = @options.delete(:api_version) { |key| DEFAULT_API_VERSION }
      @host_url = @options.delete(:host_url) { |key| host }
      @adapter = @options.delete(:adapter) { |key| Faraday.default_adapter }
    end

  end
end
