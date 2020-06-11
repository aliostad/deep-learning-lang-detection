require 'curb'
module TwitchApi
  module Api
    BASE_URL = 'https://api.twitch.tv/kraken'
    require 'twitch_api/api/request_helper'
    require 'twitch_api/api/channels'
    require 'twitch_api/api/games'
    require 'twitch_api/api/search'
    require 'twitch_api/api/blocks'
    require 'twitch_api/api/follows'
    require 'twitch_api/api/chat'
    require 'twitch_api/api/streams'
    require 'twitch_api/api/ingests'
    require 'twitch_api/api/subscriptions'
    require 'twitch_api/api/users'
    require 'twitch_api/api/teams'
  end
end
