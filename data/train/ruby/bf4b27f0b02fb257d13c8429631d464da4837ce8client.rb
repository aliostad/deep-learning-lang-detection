# -*- encoding: utf-8 -*-

module Sentiment
  class Client
    include HTTParty
    base_uri 'https://api.apphera.com/1'
    format :json

    attr_reader :api_key

    # Get a free api_key @ https://developer.apphera.com
    def initialize(api_key=nil)
      @api_key = api_key
      @api_key ||= Sentiment.api_key
      @api_path = ''
    end

    def sentiment(body, lang)
      options = {:body => {:body => body, :lang => lang}, :query => self.default_options}
      results = Mash.new(self.class.post('/sentiments', options))
      
      sentiment = results.response.polarity
    end


    protected

    def default_options
      {:api_key => @api_key}
    end

  end
end