require "httparty"
require "json"

module Reach
  class API
    include HTTParty

    require "reach/api/game"
    include Reach::API::Game

    require "reach/api/player"
    include Reach::API::Player

    require "reach/api/file"
    include Reach::API::File

    # API endpoint
    ENDPOINT = "http://www.bungie.net/api/reach/reachapijson.svc/"

    # API key
    attr_reader :key

    # Public: Creates a new API object
    #
    # key - the API key used throughout the application
    #
    # Returns a new Reach::API object
    def initialize(key)
      @key = key
    end
  end
end
