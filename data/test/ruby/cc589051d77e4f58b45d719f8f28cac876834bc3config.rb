require 'orwell/mole/errors/missing_api_token_error'

module Mole
  class Config
    DEFAULT_HOST = 'api.orwell.io'
    DEFAULT_POST = 443
    DEFAULT_API_VERSION = '1.0'

    attr_accessor :api_token
    attr_writer  :api_version, :host, :method, :port

    def api_token
      raise MissingApiTokenError unless @api_token
      @api_token
    end

    def api_version
      @api_version || DEFAULT_API_VERSION
    end

    def host
      @host || DEFAULT_HOST
    end

    def method
      @method || :basic_http
    end

    def port
      @port || DEFAULT_POST
    end
  end
end
