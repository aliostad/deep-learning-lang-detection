require "impact_radius_api/version"
require "addressable/uri"
require "cgi"
require "htmlentities"
require "httparty"
require "recursive_open_struct"
require "uri"

require "impact_radius_api/api_resource"
require "impact_radius_api/api_response"
require "impact_radius_api/version"
require "impact_radius_api/mediapartners"

require "impact_radius_api/errors/error"
require "impact_radius_api/errors/authentication_error"
require "impact_radius_api/errors/argument_error"
require "impact_radius_api/errors/not_implemented_error"
require "impact_radius_api/errors/invalid_request_error"

module ImpactRadiusAPI
  @api_base_uri = "api.impactradius.com"
  @api_timeout = 30

  class << self 
  	attr_accessor :api_base_uri, :account_sid, :auth_token, :api_version
  	attr_reader :api_timeout
  end

  def self.api_timeout=(timeout)
    raise ArgumentError, "Timeout must be a Fixnum; got #{timeout.class} instead" unless timeout.is_a? Fixnum
    raise ArgumentError, "Timeout must be > 0; got #{timeout} instead" unless timeout > 0
    @api_timeout = timeout
  end
end
