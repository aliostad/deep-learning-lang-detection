require 'noteshred/version'
require 'noteshred/api'
require 'noteshred/crypto'
require 'noteshred/tools'
require 'noteshred/note'
require 'noteshred/request'

module Noteshred
  @api_key  = nil
  @hostname = 'api.noteshred.com'
  @api_ver  = 'v1'
  @protocol = 'https'

  def self.api_key=(api_key)
    @api_key = api_key
  end

  def self.api_key
    @api_key
  end

  def self.endpoint
    "#{@protocol}://#{@hostname}/#{@api_ver}"
  end

  def self.url(rel)
    Noteshred.endpoint + rel
  end

  def self.bundle
    Noteshred::API.get('/bundle')
  end
end
