# -*- coding: utf-8 -*-

require 'json'
require 'net/http'

require_relative 'web_api_client/api_resource'
require_relative 'web_api_client/response_format'

require_relative 'web_api_client/api_resources/0.0.1/comments'

module WebAPIClient
  def self.uri=(u)
    ApiResource.api_uri = u
  end

  def self.version=(v)
    ApiResource.api_version = v
  end

  def self.format=(f)
    ApiResource.api_format = f
  end
end

# Set default values
WebAPIClient.uri = 'http://localhost:8080'
WebAPIClient.version = '0.0.1'
WebAPIClient.format = :json

