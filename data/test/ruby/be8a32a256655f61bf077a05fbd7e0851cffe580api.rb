require 'ostruct'

module Modgen
  module API

    autoload :Request,  'modgen/api/request'
    autoload :Response, 'modgen/api/response'

    autoload :APIRequest,  'modgen/api/api_request'
    autoload :APIResponse, 'modgen/api/api_response'

    autoload :Resource, 'modgen/discovery/resource'
    autoload :Method,   'modgen/discovery/method'

    @@api = nil
    @@api_methods = {}

    def self.api
      @@api || raise(Modgen::APIError, "API has not been discovered yet.")
    end

    def self.discovered?
      !@@api.nil?
    end

    # All available API methods on top
    #
    def self.methods
      @@api_methods.methods
    end

    # All api methods go there
    #
    def self.method_missing(method, *args, &block)
      api

      @@api_methods.send(method, *args, &block)
    end

    # Set api from discovery
    #
    # == Parameters:
    # api:: Hash
    #
    def self.set_api(api)
      @@api = OpenStruct.new(api)
    end

    # Set api methods from discovery
    #
    # == Parameters:
    # api:: Modgen::API::Resource
    #
    def self.set_api_methods(api)
      @@api_methods = api
    end

  end
end
