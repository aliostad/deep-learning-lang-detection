require "relate_iq/version"
require "rest_client"
require "ostruct"
require_relative "relate_iq/resource"
require_relative "relate_iq/account"
require_relative "relate_iq/contact"
require_relative "relate_iq/list_item"

module RelateIQ
  def self.configure(api_key: api_key, api_secret: api_secret)
    @api_key = api_key
    @api_secret = api_secret
  end

  def self.get(url, params)
    JSON.parse(RestClient.get("https://#{@api_key}:#{@api_secret}@api.relateiq.com/v2/#{url}", params: params))
  end

  def self.post(url, object)
    request_url = "https://#{@api_key}:#{@api_secret}@api.relateiq.com/v2/#{url}" 
    JSON.parse(RestClient.post(request_url, object.to_json, content_type: :json, accept: :json))
  end
end
