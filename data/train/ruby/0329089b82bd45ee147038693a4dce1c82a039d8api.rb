require "bokete_api_wrapper/api/base"
require "bokete_api_wrapper/api/popular"
require "bokete_api_wrapper/api/hot"
require "bokete_api_wrapper/api/legend"
require "bokete_api_wrapper/api/user"

module BoketeApiWrapper
	module Api
		def self.hot
			@hot ||= BoketeApiWrapper::Api::Hot.new
		end
		def self.popular
			@popular ||= BoketeApiWrapper::Api::Popular.new
		end
		def self.legend
			@legend ||= BoketeApiWrapper::Api::Legend.new
		end
		def self.user
			@user ||= BoketeApiWrapper::Api::User.new
		end
	end
end
