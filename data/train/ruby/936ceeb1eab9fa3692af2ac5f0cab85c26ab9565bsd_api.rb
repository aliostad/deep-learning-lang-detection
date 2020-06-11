require 'openssl'
require 'rest-client'
require 'bsd_api/version'

module BsdApi
  class XmlGenerator
    def self.get_xml(params = {})
       make_xml(params)
    end
    class << self
    private
      def make_xml(params)
        first_name = params[:first_name]
        last_name = params[:last_name]
        email = params[:email]
        username = params[:username]
        created_at = params[:created_at]
        created_string = params[:created_string] || Time.now.strftime("%m/%d/%Y")
        group_id = params[:group_id].to_s
        xml = ["<?xml version='1.0' encoding='utf-8'?>"]
        xml << "<api>"
        xml << "<cons send_password='n'>"
        xml << "<cons_group id='#{group_id}'/>" unless group_id.nil?
        xml << "<firstname>#{first_name}</firstname>" unless first_name.nil?
        xml << "<lastname>#{last_name}</lastname>" unless last_name.nil?
        xml << "<cons_email><email>#{email}</email></cons_email>" 
        xml << "<cons_field id='20'><value>#{username}</value></cons_field>"
        xml << "<cons_field id='22'><value>#{created_at}</value></cons_field>"
        xml << "<cons_field id='53'><value>#{created_string}</value></cons_field>"
        xml << "</cons>"
        xml << "</api>"
        xml.join
      end
    end
  end
  class UrlGenerator
    def self.get_url(api_host_name, api_path, api_id, api_secret)
      make_url(api_host_name, api_path, api_id, api_secret)
    end
    class << self
    private 
      def make_url(api_host_name, api_path, api_id, api_secret)

        api_ts = Time.now.utc.to_i.to_s

        api_params = "api_ver=1&api_id=#{api_id}&api_ts=#{api_ts}"

        signing_string = [api_id, api_ts, api_path, api_params].join("\n")

        api_mac = OpenSSL::HMAC.hexdigest('sha1', api_secret, signing_string)
        
        "https://#{api_host_name}#{api_path}?" + api_params + "&" + "api_mac=" + api_mac  
      end
    end
  end
  class PostConstituent
    def self.make_post(params, api_host_name, api_path, api_id, api_secret)
      xml = BsdApi::XmlGenerator.get_xml(params)
      url = BsdApi::UrlGenerator.get_url(api_host_name, api_path, api_id, api_secret)
      
      RestClient.post(url, xml, :content_type=> "text/xml")
    end
  end
end

