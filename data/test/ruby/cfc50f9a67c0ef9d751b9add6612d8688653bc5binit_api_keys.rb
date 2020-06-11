
api_creds = {}
[:flickr, :facebook, :smugmug, :shutterfly, :twitter, :yahoo, :photobucket, :ms_live,
:bitly, :mailchimp, :zza, :instagram, :dropbox].each do |service|
  all_env_keys = YAML.load(File.read("#{Rails.root}/config/#{service}_api_keys.yml"))
  api_creds[service] = all_env_keys[Rails.env]
end

FLICKR_API_KEYS       = api_creds[:flickr]
FACEBOOK_API_KEYS     = api_creds[:facebook]
SMUGMUG_API_KEYS      = api_creds[:smugmug]
SHUTTERFLY_API_KEYS   = api_creds[:shutterfly]
PHOTOBUCKET_API_KEYS  = api_creds[:photobucket]
INSTAGRAM_API_KEYS    = api_creds[:instagram]
YAHOO_API_KEYS        = api_creds[:yahoo]
TWITTER_API_KEYS      = api_creds[:twitter]
WINDOWS_LIVE_API_KEYS = api_creds[:ms_live]
DROPBOX_API_KEYS      = api_creds[:dropbox]
BITLY_API_KEYS        = api_creds[:bitly]  #YAML.load(File.read("#{Rails.root}/config/bitly_api_keys.yml"))
MAILCHIMP_API_KEYS    = api_creds[:mailchimp]
ZZA_CONFIG            = api_creds[:zza]


require 'connector_exceptions'

require 'shutterfly_connector'
require 'kodak_connector'
require 'photobucket_connector'
require 'smugmug_connector'
require 'twitter_connector'
require 'yahoo_connector'
require 'mslive_connector'

FlickRaw.api_key = FLICKR_API_KEYS[:api_key]
FlickRaw.shared_secret = FLICKR_API_KEYS[:shared_secret]

ShutterflyConnector.app_id = SHUTTERFLY_API_KEYS[:app_id]
ShutterflyConnector.shared_secret = SHUTTERFLY_API_KEYS[:shared_secret]

Instagram.configure do |config|
  config.client_id = INSTAGRAM_API_KEYS[:client_id]
  config.client_secret = INSTAGRAM_API_KEYS[:client_secret]
end

PhotobucketConnector.consumer_key = PHOTOBUCKET_API_KEYS[:consumer_key]
PhotobucketConnector.consumer_secret = PHOTOBUCKET_API_KEYS[:consumer_secret]

SmugmugConnector.api_key = SMUGMUG_API_KEYS[:api_key]
SmugmugConnector.shared_secret = SMUGMUG_API_KEYS[:shared_secret]

YahooConnector.api_key = YAHOO_API_KEYS[:app_key]
YahooConnector.shared_secret = YAHOO_API_KEYS[:consumer_secret]

MsliveConnector.client_id = WINDOWS_LIVE_API_KEYS[:client_id]
MsliveConnector.secret_key = WINDOWS_LIVE_API_KEYS[:secret_key]
MsliveConnector.tos_url = "http://#{Server::Application.config.application_host}/tos.html"


msg = "=> Connector API keys loaded."
Rails.logger.info msg
puts msg
