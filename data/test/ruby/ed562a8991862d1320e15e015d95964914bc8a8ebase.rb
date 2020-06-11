require 'wiziq/error/no_such_api_method'
require 'wiziq/http_connection'
require 'wiziq/api_constants'
require 'wiziq/configuration'
require 'wiziq/auth'

module Wiziq
	class Base
		include ApiConstants		
		attr_accessor :auth, :configuration
		
		def initialize(access_key=nil,secret_key=nil)
			@configuration = Wiziq::Configuration.new

			if block_given?
				yield(@configuration)
				print "config init base #{ @configuration} "
			else
				@configuration.access_key = access_key				
				@configuration.secret_key = secret_key
			end 
		end

		def call_api_method(api_method,api_params={})
			raise NoSuchAPIMethod, api_method  unless  API_METHODS.include? api_method
			api_response = api_request(api_method,api_params)
			api_response.body
		end 

		def api_request(api_method,api_params)
		    			
			url = "#{CLASS_API_ENDPOINT}/?method=#{api_method}"								

			@auth  ||= Wiziq::Auth.new(@configuration.access_key, @configuration.secret_key)

			auth_params = @auth.get_auth_params(api_method)
						
			api_params["signature"] = @auth.get_signature_digest

			request_params = api_params.merge(auth_params)
			Wiziq::HttpConnection.post(url,request_params,{ "User-Agent"=> USER_AGENT })
		end
	end
end