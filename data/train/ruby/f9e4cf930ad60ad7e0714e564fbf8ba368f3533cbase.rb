module Nytimes
  module Events
    class Base
      API_SERVER = 'api.nytimes.com'
      API_VERSION = 'v2'
      API_NAME = 'events'
      API_OBJECTS = 'listings'
      RESPONSE_TYPE = 'json'
      API_URL = "http://#{API_SERVER}/svc/#{API_NAME}/#{API_VERSION}/listings.#{RESPONSE_TYPE}"

      def initialize(api_key)
        @api_key = api_key
      end

      def api_key=(key)
        @api_key = key
      end

      def api_key
        @api_key
      end

      def api_url(params)
        prmstr = params.collect { |k, v| "#{k.to_s}=#{v.to_s.gsub(' ','+')}" }.join('&') + "&api-key=" + api_key
        API_URL + "?" + prmstr
      end
    end
  end
end