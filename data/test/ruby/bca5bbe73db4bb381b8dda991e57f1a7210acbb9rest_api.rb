require "rest_api/exceptions"
require "rest_api/version"
require "rest_api/api"
require "rest_api/request_handler"
require "rest_api/custom_api_method_call"

module RestApi

  @@custom_methods = []

  # SETUP
  def self.setup
    yield self
  end

  def self.api_url
    self.api.url
  end

  def self.api_url=(value)
    if value.match(/.+\/$/)
      self.api.url = value
    else
      self.api.url = value + "/"
    end
  end

  def self.api_key_name
    self.api.api_key_name
  end

  def self.api_key_name=(value)
    self.api.api_key_name = value
  end

  def self.api_key_value
    self.api.api_key_value
  end

  def self.api_key_value=(value)
    self.api.api_key_value = value
  end
  
  # api reference
  def self.api
    RestApi::API
  end

  # request reference
  def self.request
    RestApi::RequestHandler
  end

  # request parser reference
  def self.request_parser
    RestApi::API::RequestParser
  end
end
