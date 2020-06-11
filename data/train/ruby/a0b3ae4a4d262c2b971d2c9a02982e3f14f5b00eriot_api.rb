module RiotAPI
  require 'faraday'
  require 'extlib'
  
  require_relative 'riot_api/strategies/default'
  require_relative 'riot_api/strategies/summoner'
  require_relative 'riot_api/strategies/team'
  require_relative 'riot_api/strategies/champion'
  require_relative 'riot_api/strategies/game'
  require_relative 'riot_api/strategies/league'
  require_relative 'riot_api/strategies/stats'
  require_relative 'riot_api/strategies/lol_static_data'
  require_relative 'riot_api/strategies/icon'
  
  require_relative 'riot_api/api'
  require_relative 'riot_api/requester'
  
end
