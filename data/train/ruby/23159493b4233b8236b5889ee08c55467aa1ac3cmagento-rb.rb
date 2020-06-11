require "magento/api_error"
require "magento/soap_api_v2"
require "magento/xml_api"

module Magento
  
  def self.api_endpoint=(value)
    @@xml_api = nil
    @@soap_api = nil
    @@api_endpoint = value
  end
  
  def self.api_username=(value)
    @@xml_api = nil
    @@soap_api = nil
    @@api_username = value
  end
  
  def self.api_password=(value)
    @@xml_api = nil
    @@soap_api = nil
    @@api_password = value
  end
  
  def self.debug=(value)
    @@xml_api = nil
    @@debug = value
  end
  
  def self.xml_api(debug = nil)
    @@xml_api = nil if debug
    @@xml_api ||= XmlApi.new @@api_endpoint, @@api_username, @@api_password, :debug => debug || @@debug || false
  end
  
  def self.soap_api
    @@soap_api ||= SoapApiV2.new @@api_endpoint, @@api_username, @@api_password
  end
  
end