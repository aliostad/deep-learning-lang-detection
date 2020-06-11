# encoding: utf-8
require 'forwardable'
require 'viglink_api/request'
require 'viglink_api/product'
require 'viglink_api/deal'
require 'viglink_api/merchant'
require 'viglink_api/country'

module ViglinkApi
  class Client
    extend Forwardable

    include Request
    include Product
    include Deal
    include Merchant
    include Country

    attr_reader :api_key, :api_url, :api_full_response

    ##
    # Create a new Viglink::Client object
    #
    # @params options [Hash]
    def initialize(options={})
      @api_key = options[:api_key] || ViglinkApi.api_key
      @api_url = options[:api_url] || ViglinkApi.api_url
      @api_full_response = options[:api_full_response] || ViglinkApi.api_full_response
    end

    ##
    # Create a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      params = {}
      @connection = Faraday.new(url: api_url, params: params, headers: default_headers) do |faraday|
        faraday.use FaradayMiddleware::Mashify
        faraday.use FaradayMiddleware::ParseXml, content_type: /\bxml$/
        # faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
    end

    private

    def default_headers
      headers = {
        accept: '*/*',
        content_type: 'text/xml',
        user_agent: "Ruby Gem #{ViglinkApi::VERSION}"
      }
    end

  end
end
