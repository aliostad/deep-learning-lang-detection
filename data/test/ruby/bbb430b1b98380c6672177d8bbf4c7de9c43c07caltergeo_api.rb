require "altergeo_api/version"
require "altergeo_api/error"
require "altergeo_api/request"
require "altergeo_api/client"
require "altergeo_api/resource"
require "altergeo_api/resource_collection"
require "altergeo_api/place"
require "altergeo_api/place_collection"
require "altergeo_api/checkin"
require "altergeo_api/checkin_collection"
require "altergeo_api/type"
require "altergeo_api/type_collection"

module AltergeoApi

  class << self
    def enable_will_paginate!
      require 'altergeo_api/will_paginator'
      AltergeoApi::ResourceCollection.send(:include, AltergeoApi::WillPaginator)
    end

    def method_missing(method, *args, &block)
      AltergeoApi::Client.send(method, *args, &block)
    end
  end

end
