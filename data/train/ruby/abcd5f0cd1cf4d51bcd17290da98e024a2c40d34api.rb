require 'app/apis/base_api'
require 'app/apis/authorizations_api'
require 'app/apis/beers_api'
require 'app/apis/breweries_api'
require 'app/apis/events_api'
require 'app/apis/guilds_api'
require 'app/apis/ingredients_api'
require 'app/apis/styles_api'
require 'app/apis/users_api'
require 'app/apis/webhooks_api'
require 'sidekiq/web'

module Goodbrews
  class API < BaseAPI
    respond_to :json, :html

    get do
      case format
      when :html
        redirect_to 'https://goodbrews.github.com/api'
      when :json
        {
          _links: {
            authorizations: { href: '/authorizations', methods: %w[POST DELETE] },
            beers:          { href: '/beers' },
            breweries:      { href: '/breweries' },
            events:         { href: '/events' },
            guilds:         { href: '/guilds' },
            ingredients:    { href: '/ingredients' },
            styles:         { href: '/styles' }
          }
        }
      end
    end

    mount AuthorizationsAPI => :authorizations
    mount BeersAPI          => :beers
    mount BreweriesAPI      => :breweries
    mount EventsAPI         => :events
    mount GuildsAPI         => :guilds
    mount IngredientsAPI    => :ingredients
    mount StylesAPI         => :styles
    mount UsersAPI          => :users
    mount WebhooksAPI       => '/brewery_db/webhooks/'

    mount Sidekiq::Web => '/sidekiq/:key', constraints: { key: ENV['BREWERY_DB_API_KEY'] }
  end
end
