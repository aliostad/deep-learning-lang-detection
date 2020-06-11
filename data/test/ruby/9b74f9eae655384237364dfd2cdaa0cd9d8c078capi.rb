require "immobilienscout24/api/connection"
require "immobilienscout24/api/request"
require "immobilienscout24/api/request/base"
require "immobilienscout24/api/request/json"
require "immobilienscout24/api/request/xml"
require "immobilienscout24/api/search"
require "immobilienscout24/api/user"
require "immobilienscout24/api/real_estate"
require "immobilienscout24/api/publish"
require "immobilienscout24/api/attachment"
require "immobilienscout24/api/contact"
require "immobilienscout24/api/gis"

module Immobilienscout24
  module Api
    include Connection
    include Request
    include Search
    include User
    include RealEstate
    include Publish
    include Attachment
    include Contact
    include Gis

  end
end
