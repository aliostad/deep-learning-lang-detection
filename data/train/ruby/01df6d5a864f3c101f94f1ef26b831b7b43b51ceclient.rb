require 'viagogo/client'
require 'viagogo/public/api/categories'
require 'viagogo/public/api/countries'
require 'viagogo/public/api/events'
require 'viagogo/public/api/geographies'
require 'viagogo/public/api/listings'
require 'viagogo/public/api/metro_areas'
require 'viagogo/public/api/venues'
require 'viagogo/public/oauth'

module Viagogo
  module Public
    # Client for the viagogo API public service
    #
    # @see http://developer.viagogo.net/documentation/description-of-services/public-services
    class Client < Viagogo::Client
      include Viagogo::Public::API::Categories
      include Viagogo::Public::API::Countries
      include Viagogo::Public::API::Events
      include Viagogo::Public::API::Geographies
      include Viagogo::Public::API::Listings
      include Viagogo::Public::API::MetroAreas
      include Viagogo::Public::API::Venues
      include Viagogo::Public::OAuth
    end
  end
end
