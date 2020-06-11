require 'rest-client'

module QAIT
module Test
class Api

  attr_accessor :api, :api_key

  def initialize base_url, api_key
    @api = RestClient::Resource.new base_url
    @api_key = api_key
  end

  def get path
    @api[path].get :content_type=>:json, :accept=>:json, "X-Api-Key"=>@api_key
  end

  def post path, payload
    @api[path].post payload, :content_type=>:json, :accept=>:json, "X-Api-Key"=>@api_key
  end

  def put path, payload
    @api[path].put payload, :content_type=>:json, :accept=>:json, "X-Api-Key"=>@api_key
  end

  def delete path, payload=nil
    @api[path].delete payload, :content_type=>:json, :accept=>:json, "X-Api-Key"=>@api_key
  end

end
end
end # module QAIT