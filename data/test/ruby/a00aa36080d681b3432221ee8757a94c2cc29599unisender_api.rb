require "unisender_api/version"
require "unisender_api/api_call"
require "unisender_api/extends"
require "unisender_api/lists"
require "unisender_api/message"
require "unisender_api/partners"
require "unisender_api/statistics"


module Unisender

  class API
    
    attr_accessor :api, :lists, :messages, :statistics, :extends, :partners
    
    def initialize(api_key, locale = 'en', test = false)
      self.api = ApiCall.new(api_key, locale, test)
      @lists = Lists.new(self.api)
      @messages = Messages.new(self.api)
      @statistics = Statistics.new(self.api)
      @extends = Extends.new(self.api)
      @partners = Partners.new(self.api)
    end

    def lists
      @lists
    end

    def messages
      @messages
    end

    def statistics
      @statistics
    end

    def extends
      @extends
    end

    def partners
      @partners
    end

  end
  
  
end
