module Fyber
  module HTTP
    module Service
      class Base
        attr_reader :connection, :api_server, :api_namespace, :api_key

        DEFAULT_CONFIG_OPTIONS = {
          api_server: '',
          api_namespace: '',
          api_key: ''
        }

        def initialize(api_server: nil, api_namespace: nil)
          @api_server = api_server || self.class.config.api_server
          @api_namespace = api_namespace || self.class.config.api_namespace

          @connection = ::Faraday.new(url: @api_server) do |faraday|
            faraday.request :network_exception
            faraday.adapter :net_http
          end
        end

        def self.config
          @config ||= Fyber::Configuration.new(DEFAULT_CONFIG_OPTIONS)
        end

        def self.configure
          yield(config)
        end
      end
    end
  end
end
