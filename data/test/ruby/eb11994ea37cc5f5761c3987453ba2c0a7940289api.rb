# coding: utf-8
require 'entities'
require 'helpers'
require 'search_api'
require 'users_api'
require 'purchase_api'
require 'law_type_api'
require 'laws_api'
require 'cases_api'
# require 'cases_api_v2'
require 'active_api'
require 'law_content_api'
require 'invite_api'
require 'favorites_api'
require 'reports_api'

require 'data_import_api'

module Faxin
  class API < Grape::API
    prefix :api
    format :json
    
    helpers APIHelpers
    
    mount UsersAPI
    mount ActiveAPI
    mount PurchaseAPI
    mount SearchAPI
    mount LawTypeAPI
    mount CasesAPI
    mount LawsAPI
    
    mount FavoritesAPI
    
    mount InviteAPI
    
    mount ReportsAPI
    
    # 此接口专为ios正式版
    mount LawContentAPI
    
    # 录入数据接口
    # mount DataImportAPI
    
  end

end