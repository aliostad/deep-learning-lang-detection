module GeoAPI
  class Client

    # To connect to GeoAPI, either:
    #
    # Add export GEOAPI_KEY=<your-api-key> in your .bashrc file
    # 
    # @client = GeoAPI::Client.new
    #
    # OR
    #
    # @client = GeoAPI::Client.new('<your-api-key>')  
    #
    # OR set GEOAPI_KEY='<your-api-key>' before including GeoAPI
    #
    # @client = GeoAPI::Client.new
    
    def initialize(api_key=nil)
      @api_key = api_key || ENV['GEOAPI_KEY'] || GeoAPI::GEOAPI_KEY
    end
    
    def api_key
      @api_key
    end
    
    def self.id_from_guid(guid,apikey)
      id = guid.sub('user-','')
      id = id.sub("#{apikey}-",'')
    end
  
  end
end