require 'active_support/core_ext'
require 'httparty'
require 'hmac-sha2'

require "bitstamp_api/rest"
require "bitstamp_api/data"
require "bitstamp_api/account"
require "bitstamp_api/limit_order"
require "bitstamp_api/withdrawal"
require "bitstamp_api/deposit"
require "bitstamp_api/ripple"


# DOCS: https://www.bitstamp.net/api/
module BitstampAPI

  # Set key defaults based on ENV vars
  mattr_accessor :api_key
  self.api_key = ENV["BITSTAMP_API_KEY"]

  mattr_accessor :api_secret
  self.api_secret = ENV["BITSTAMP_API_SECRET"]

  mattr_accessor :client_id
  self.client_id = ENV["BITSTAMP_CLIENT_ID"]

  def self.configure
    yield(self)
  end

end
