require 'ov'

module TvrageApi
  module AttributesMapping
    module Recap; end
    module Search; end
    module Show; end
  end
end

require 'tvrage_api/attributes_mapping/recap/show'
require 'tvrage_api/attributes_mapping/search/by_name'
require 'tvrage_api/attributes_mapping/show/episode'
require 'tvrage_api/attributes_mapping/show/find'
require 'tvrage_api/version'
require 'tvrage_api/client'
require 'tvrage_api/base'
require 'tvrage_api/search'
require 'tvrage_api/show'
require 'tvrage_api/update'
require 'tvrage_api/info'
require 'tvrage_api/schedule'
require 'tvrage_api/recap'
