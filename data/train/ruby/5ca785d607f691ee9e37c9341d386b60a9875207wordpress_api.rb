require 'omniauth-oauth2'

module WordpressApi

  class << self
    attr_accessor :token, :secret

    # config/initializers/wordpress_api.rb (for instance)
    #
    # WordpressApi.configure do |config|
    #   config.token = 'consumer_token'
    #   config.secret = 'consumer_secret'
    #   config.default_profile_fields = ['education', 'positions']
    # end
    #
    # elsewhere
    #
    # client = WordpressApi::Client.new
    def configure
      yield self
      true
    end
  end

  autoload :Api,     "wordpress_api/api"
  autoload :Client,  "wordpress_api/client"
  autoload :Mash,    "wordpress_api/mash"
  autoload :Errors,  "wordpress_api/errors"
  autoload :Helpers, "wordpress_api/helpers"
  autoload :Version, "wordpress_api/version"
end
