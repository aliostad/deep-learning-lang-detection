module Loaderio
  module Configuration
    extend self
        
    attr_accessor :api_key, :api_version, :protocol, :server
    
    #default values
    self.api_version = "v1"
    self.protocol    = "https"
    self.server      = "api.loader.io"
    self.api_key     = ENV["LOADERIO_API_KEY"]
    def base_url
      "#{protocol}://#{server}/#{api_version}"
    end
    
    def resource
      RestClient::Resource.new(base_url, headers: {"loaderio-Auth" => api_key, content_type: :json, accept: :json })
    end
  end
end
