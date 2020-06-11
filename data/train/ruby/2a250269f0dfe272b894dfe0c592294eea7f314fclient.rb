module Wowzer

  class Client
    include Hyperclient

    attr_accessor :api

    def connect
      api_endpoint = @api_endpoint
      app_id = @app_id
      api_key = @api_key

      self.api ||= Hyperclient.new(api_endpoint).tap do |api|
        api.basic_auth(app_id, api_key)
        api.headers.merge({'accept' => 'application/hal+json', 'content-type' => 'application/json'})
      end
    end

    def method_missing(method, *args, &block)
      if api.respond_to?(method)
        api.send(method, *args, &block)
      else
        super
      end
    end

    def app_id(app_id)
      @app_id = app_id
    end

    def api_key(api_key)
      @api_key = api_key
    end

    def api_endpoint(api_endpoint)
      @api_endpoint = api_endpoint
    end

  end

end