module Restpie
  module ControllerExtensions
    
    @@api_info = {
      :params => [],
      :codes => []
    }
    
    def restpie_api_info
      @@api_info
    end
    
    def clear_restpie_api_info
      @@api_info = {
        :params => [],
        :codes => []
      }
    end
    
    def _api(method, path, description)
      @@api_info[:api] = Restpie::API::Api.new(method, path, description)
    end
    
    def _description(description)
      @@api_info[:description] = description
    end
    
    def _param(name, options={})
      @@api_info[:params] << Restpie::API::Param.new(name, options)
    end
    
    def _code(code, description)
      @@api_info[:codes] << Restpie::API::ResponseCode.new(code, description)
    end
    
    def _formats(formats)
      @@api_info[:formats] = formats
    end
    
    def _request_schema(schema)
      @@api_info[:request_schema] = schema
    end
    
    def _response_schema(schema)
      @@api_info[:response_schema] = schema
    end
  end
end