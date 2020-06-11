# coding: utf-8
require "helpers"
require "entities"

require "auth_codes_api"
require "users_api"
require "items_api"
require "orders_api"

module API
  class APIV1 < Grape::API
    prefix :api
    version 'v1'
    format :json
    
    # 异常处理
    rescue_from :all do |e|
      case e
      when ActiveRecord::RecordNotFound
        Rack::Response.new(['not found'], 404, {}).finish
      else
        Rails.logger.error "APIv1 Error: #{e}\n#{e.backtrace.join("\n")}"
        Rack::Response.new(['error'], 500, {}).finish
      end
    end
    
    helpers APIHelpers
    
    mount API::AuthCodesAPI
    mount API::UsersAPI
    mount API::ItemsAPI
    mount API::OrdersAPI
    
  end
end