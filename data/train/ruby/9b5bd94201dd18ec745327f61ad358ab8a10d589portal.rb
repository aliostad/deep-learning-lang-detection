require 'hubspot-api/connection'
require 'hubspot-api/api'

# Representation of a Hubspot portal.
class Hubspot::Portal
  attr_reader :connection, :portal_id, :name

  def initialize(name, portal_id, auth)
    @name = name
    @portal_id = portal_id
    @connection = Hubspot::Connection.new(auth)
    initialize_apis!
    freeze
  end

  private

  def initialize_apis!
    Hubspot::APIS.each { |api| initialize_api!(api, Hubspot::Api.lookup(api)) }
  end

  def initialize_api!(name, api)
    interface = api.new(self).freeze
    instance_variable_set("@#{name}", interface)
    singleton_class.class_eval { attr_reader name }
  end
end
