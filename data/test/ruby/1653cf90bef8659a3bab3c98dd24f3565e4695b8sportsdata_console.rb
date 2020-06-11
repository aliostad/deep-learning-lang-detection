require 'rubygems'
require 'awesome_print'
require 'sportsdata'
require 'debugger'
require 'pry'

Sportsdata.configure do |config|
  config.nfl_api_key            = ENV['SPORTSDATA_NFL_API_KEY']
  config.nfl_images_api_key     = ENV['SPORTSDATA_NFL_IMAGES_API_KEY']
  config.mlb_api_key            = ENV['SPORTSDATA_MLB_API_KEY']
  config.mlb_images_api_key     = ENV['SPORTSDATA_MLB_IMAGES_API_KEY']
  config.nhl_api_key            = ENV['SPORTSDATA_NHL_API_KEY']
  config.nhl_images_api_key     = ENV['SPORTSDATA_NHL_IMAGES_API_KEY']
  config.nba_api_key            = ENV['SPORTSDATA_NBA_API_KEY']
  config.nba_images_api_key     = ENV['SPORTSDATA_NBA_IMAGES_API_KEY']
  config.ncaafb_api_key         = ENV['SPORTSDATA_NCAAFB_API_KEY']
  config.ncaafb_images_api_key  = ENV['SPORTSDATA_NCAAFB_IMAGES_API_KEY']
  config.ncaamb_api_key         = ENV['SPORTSDATA_NCAAMB_API_KEY']
  config.ncaamb_images_api_key  = ENV['SPORTSDATA_NCAAMB_IMAGES_API_KEY']
  config.nascar_api_key         = ENV['SPORTSDATA_NASCAR_API_KEY']
  config.nascar_images_api_key  = ENV['SPORTSDATA_NASCAR_IMAGES_API_KEY']
  config.golf_api_key           = ENV['SPORTSDATA_GOLF_API_KEY']
  config.golf_images_api_key    = ENV['SPORTSDATA_GOLF_IMAGES_API_KEY']
  config.api_mode               = ENV['SPORTSDATA_API_MODE']
  config.images_api_mode        = ENV['SPORTSDATA_IMAGES_API_MODE']
end
