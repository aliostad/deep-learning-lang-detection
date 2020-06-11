require 'rubygems'
require 'bundler/setup'

require 'httparty'
require 'virtus'

require "blackbook_api/version"
require "blackbook_api/configure"

require "blackbook_api/errors/blackbook_api_error"
require "blackbook_api/errors/blackbook_api_error_handler"
require "blackbook_api/errors/authentication_error"
require "blackbook_api/errors/request_failure_handler"
require "blackbook_api/errors/request_failed_error"

require "blackbook_api/client"
require "blackbook_api/add_deduct_item"
require "blackbook_api/mileage_item"
require "blackbook_api/vehicle_make"
require "blackbook_api/vehicle"

module BlackbookApi
  extend Configure
end
