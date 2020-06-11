module Exchange
  class ApiCaller < Dialers::Caller
    API_PROTOCOL = ENV["API_PROTOCOL"]
    API_HOST = ENV["API_HOST"]
    API_PORT = ENV["API_PORT"]
    API_APP_KEY = ENV["API_APP_KEY"]
    API_BASE_URL = "#{API_PROTOCOL}://#{API_HOST}:#{API_PORT}/api/v1/private?app_key=#{API_APP_KEY}"
    TIMEOUT_IN_SECONDS = 120

    setup_api(url: API_BASE_URL) do |faraday|
      faraday.request :json
      faraday.response :json
      #faraday.adapter :patron
      faraday.adapter :net_http
      faraday.options.timeout = TIMEOUT_IN_SECONDS
      faraday.options.open_timeout = TIMEOUT_IN_SECONDS
    end
  end
end
