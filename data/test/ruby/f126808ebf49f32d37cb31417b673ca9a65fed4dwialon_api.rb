require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/parse_oj'
require 'yaml'
require 'hashie'

require 'wialon_api/version'
require 'wialon_api/error'
require 'wialon_api/configuration'
require 'wialon_api/authorization'
require 'wialon_api/api'
require 'wialon_api/resolver'
require 'wialon_api/resolvable'
require 'wialon_api/client'
require 'wialon_api/namespace'
require 'wialon_api/method'
require 'wialon_api/result'
require 'wialon_api/logger'

module WialonApi
  extend WialonApi::Authorization
  extend WialonApi::Configuration
end
