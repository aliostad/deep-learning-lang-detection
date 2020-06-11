require 'bunsen'
module Bunsen
  class API
    
    def self.create api_options
      api_resolved = nil
      api_options.each { |api,config|
        hyper_class = case api
        when /^ucs$/
          Bunsen::UCS
        when /^vsphere$/
          Bunsen::Vsphere
        else
          # custom api
          begin
            require "bunsen/api/#{api}"
          rescue LoadError
            raise "Invalid api: #{api}"
          end
          Bunsen.const_get api.capitalize
        end
        api_resolved = hyper_class.new config
      }
      api_resolved
    end
    
    
  end
end
[ 'ucs', 'vsphere'].each do |lib|
  require "bunsen/api/#{lib}"
end