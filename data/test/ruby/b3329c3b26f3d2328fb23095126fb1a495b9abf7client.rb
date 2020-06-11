require 'cassette-rack'
require 'smartdc/auth'
require 'smartdc/api/datacenters'
require 'smartdc/api/images'
require 'smartdc/api/packages'
require 'smartdc/api/keys'
require 'smartdc/api/machines'
require 'smartdc/api/machines/tags'
require 'smartdc/api/machines/metadata'
require 'smartdc/api/machines/snapshots'
require 'smartdc/api/analytics'
require 'smartdc/api/analytics/heatmap'

module Smartdc
  class Client
    include CassetteRack::Request
    include Smartdc::Api::Datacenters
    include Smartdc::Api::Images
    include Smartdc::Api::Packages
    include Smartdc::Api::Keys
    include Smartdc::Api::Machines
    include Smartdc::Api::Machines::Tags
    include Smartdc::Api::Machines::Metadata
    include Smartdc::Api::Machines::Snapshots
    include Smartdc::Api::Analytics
    include Smartdc::Api::Analytics::Heatmap

    def initialize(options={})
      options = Smartdc.config.options.merge(options)
      auth = Smartdc::Auth.new(options)
      date = Time.now.gmtime.to_s

      @request_options = {
        builder: options[:middleware],
        url: options[:url],
        ssl: { verify: options[:ssl_verify] },
        headers: {
          date: date, authorization: auth.signature(date),
          'content-type' => 'application/json', accept: 'application/json',
          'x-api-version' => options[:version]
        }
      }
    end
  end
end
