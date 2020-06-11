# coding: utf-8
require "helpers"
require "entities"

require "auth_codes_api"
require "users_api"
require "categories_api"
require "banners_api"
require "goals_api"
require "notes_api"
require "supervises_api"
require "messages_api"

module API
  class APIV1 < Grape::API
    prefix :api
    version 'v1'
    format :json
    
    # 异常处理
    rescue_from :all do |e|
      case e
      when ActiveRecord::RecordNotFound
        Rack::Response.new(['数据不存在'], 404, {}).finish
      when Grape::Exceptions::ValidationErrors
        Rack::Response.new([{
          error: "参数不符合要求，请检查参数是否按照 API 要求传输。",
          validation_errors: e.errors
        }.to_json], 400, {}).finish
      else
        Rails.logger.error "APIv1 Error: #{e}\n#{e.backtrace.join("\n")}"
        Rack::Response.new([{ error: "API 接口异常"}.to_json], 500, {}).finish
      end
    end
    
    helpers APIHelpers
    
    # mount API::AuthCodesAPI
    mount API::UsersAPI
    mount API::CategoriesAPI
    mount API::BannersAPI
    mount API::GoalsAPI
    mount API::NotesAPI
    mount API::SupervisesAPI
    mount API::MessagesAPI
    
  end
end