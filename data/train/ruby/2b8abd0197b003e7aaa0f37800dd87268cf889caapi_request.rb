require "httparty"

module Singly
  API_BASE = "api.singly.com"
  API_PROTOCOL = "https://"

  module ApiRequest
    def api_base
      @api_base || API_BASE
    end

    def api_url(path)
      API_PROTOCOL + api_base + path
    end

    def get(path, query={})
      url = api_url(path)
      query = query.merge(:access_token => @access_token) if @access_token
      options = {}
      options[:query] = query if query.any?
      http = HTTParty.get(url, options)
      return JSON.parse(http.body) if http.success?
      raise Net::HTTPError.new(http.response.message, http.response)
    end
  end
end
