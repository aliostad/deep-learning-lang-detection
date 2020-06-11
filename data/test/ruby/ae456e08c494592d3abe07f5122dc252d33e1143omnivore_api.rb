require "omnivore_api/version"

module OmnivoreApi
  require 'omnivore_api/client'

  require 'omnivore_api/api/base'
  require 'omnivore_api/api/employee'
  require 'omnivore_api/api/location'
  require 'omnivore_api/api/menu'
  require 'omnivore_api/api/menu_category'
  require 'omnivore_api/api/menu_item'
  require 'omnivore_api/api/menu_modifier'
  require 'omnivore_api/api/menu_modifier_group'
  require 'omnivore_api/api/order_type'
  require 'omnivore_api/api/table'
  require 'omnivore_api/api/tender_type'
  require 'omnivore_api/api/ticket'
  require 'omnivore_api/api/ticket_item'
  require 'omnivore_api/api/ticket_item_modifier'

  # dependencies
  require 'faraday'
  require 'faraday_middleware'

end
