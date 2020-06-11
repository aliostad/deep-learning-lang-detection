# encoding: utf-8

require 'json'

module SCB
  class API
    class Config
      attr_accessor :api_host, :api_name, :api_version,
                    :language, :database, :http_client, :json_parser

      def initialize
        @api_host    = 'api.scb.se'
        @api_name    = 'OV0104'
        @api_version = 'v1/doris'
        @language    = 'sv'
        @database    = 'ssd'
        @http_client = SCB::HTTP
        @json_parser = JSON

        yield self if block_given?
      end

      def base_url
        "http://#{api_host}/#{api_name}/#{api_version}/#{language}/#{database}"
      end

      def self.language(language)
        new { |c| c.language = language }
      end
    end
  end
end
