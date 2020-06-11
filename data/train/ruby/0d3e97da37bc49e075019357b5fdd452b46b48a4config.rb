# 
# Moviepilot CLI configuration
# 

require 'active_support/configurable'

module Moviepilot
  include ActiveSupport::Configurable

  DEFAULT_API_HOST = 'api.moviepilot.com'
  DEFAULT_API_VERSION = 'v4'
  VERSION = '0.0.1'

  # Available configuration
  config_accessor :api_host, :api_version

  # Set the configuration using a block
  def self.configure(&block)
    yield self
  end

  # Initial configuration
  configure do |config|
    config.api_host = DEFAULT_API_HOST
    config.api_version = DEFAULT_API_VERSION
  end
end