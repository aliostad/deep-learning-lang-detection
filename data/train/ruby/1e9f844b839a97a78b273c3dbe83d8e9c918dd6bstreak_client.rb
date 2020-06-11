require 'rest-client'
require 'multi_json'

require 'resources/box'
require 'resources/newsfeed'
require 'resources/pipeline'
require 'resources/snippet'
require 'resources/stage'
require 'resources/thread'
require 'resources/user'

module StreakClient

  @@api_protocol = "https"
  @@api_key = nil
  @@api_base_url = "www.streak.com/api"
  @@api_version = "v1"

  def self.api_key=(key)
    @@api_key = key
  end

  def self.api_key
    @@api_key
  end

  def self.api_base_url
    @@api_base_url
  end

  def self.api_protocol
    @@api_protocol
  end

  def self.api_version
    @@api_version
  end

  def self.api_url
    "#{api_protocol}://#{api_key}@#{api_base_url}/#{api_version}"
  end

end
