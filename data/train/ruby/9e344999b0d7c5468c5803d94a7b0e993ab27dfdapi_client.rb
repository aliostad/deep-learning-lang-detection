require "api_client/version"
require "faraday"
require "hashie"
require "multi_json"

module ApiClient
  class << self
    attr_accessor :logger
  end

  module Mixins
    require "api_client/mixins/connection_hooks"
    require "api_client/mixins/delegation"
    require "api_client/mixins/configuration"
    require "api_client/mixins/inheritance"
    require "api_client/mixins/instantiation"
    require "api_client/mixins/scoping"
  end

  require "api_client/base"
  require "api_client/errors"
  require "api_client/scope"
  require "api_client/utils"

  module Resource
    require "api_client/resource/base"
    require "api_client/resource/scope"
    require "api_client/resource/name_resolver"
  end

  module Connection
    class << self
      attr_accessor :default
    end
    self.default = :basic

    module Middlewares
      module Request
        require "api_client/connection/middlewares/request/oauth"
        require "api_client/connection/middlewares/request/logger"
        require "api_client/connection/middlewares/request/json"
      end
    end

    require "api_client/connection/abstract"
    require "api_client/connection/basic"
    require "api_client/connection/json"
    require "api_client/connection/oauth"
  end
end
