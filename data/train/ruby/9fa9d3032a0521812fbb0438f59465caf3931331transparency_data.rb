require 'hashie'
require 'json'
require 'monster_mash'

Hash.send :include, Hashie::HashExtensions



module TransparencyData
  
  VERSION = "0.0.4".freeze
  
  def self.configure
    yield self
    true
  end
  
  def self.api_version
    @api_version || "1.0"
  end
  
  def self.api_version=(value)
    @api_version = value
  end
  
  def self.api_key
    @api_key
  end
  
  def self.api_key=(value)
    @api_key = value
  end
  
  def self.api_domain
    @api_domain || "transparencydata.com"
  end
  
  def self.api_domain=(value)
    @api_domain = value
  end
  
  def self.api_url(endpoint, version = self.api_version)
    "http://#{self.api_domain}/api/#{version}#{endpoint}.json"
  end
  
end

Dir.glob(File.dirname(__FILE__) + '/transparency_data/*.rb').each { |f| require f }