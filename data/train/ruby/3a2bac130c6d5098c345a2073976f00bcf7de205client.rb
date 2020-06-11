module Infogram
  class Client
    API_URL = 'https://infogr.am/service/v1'

    attr_accessor :config

    def initialize(api_key, api_secret)
      config(api_key: api_key, api_secret: api_secret)
    end

    def config(opts = {})
      @config ||= {
        api_key: opts[:api_key],
        api_secret: opts[:api_secret],
        api_url: API_URL
      }
    end

    def themes
      @themes ||= Infogram::Themes.new(config)
    end

    def infographics
      @infographics ||= Infogram::Infographics.new(config)
    end

    def users
      @users ||= Infogram::Users.new(config)
    end
  end
end
