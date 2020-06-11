module Rovi
  
  class Api
    include HTTParty
    
    @@host = "http://api.rovicorp.com"    
    
    def initialize(api_key, api_secret)
      @api_key, @api_secret = api_key, api_secret
      @version = "v1"
      @service_name = "data"
    end
    
    def get(function, function_request, params)
      @api_function, @api_function_request = function, function_request
      params.merge!({ :apikey => @api_key, :sig => generate_sig })      
      JsonResponse.new(self.class.get(endpoint, :query => params).parsed_response)
    end
    
    private
    
    def generate_sig
      Digest::MD5.hexdigest(@api_key + @api_secret + Time.now.to_i.to_s) 
    end
    
    def endpoint
      [@@host, @service_name, @version, @api_function, @api_function_request].join("/")
    end
    
  end
  
end
