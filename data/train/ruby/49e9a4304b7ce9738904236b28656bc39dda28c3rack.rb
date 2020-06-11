require 'rack'

require './api/seeds'
require './api/orders'
require './api/employees'
require './api/locations'
require './api/places'
require './api/accounts'

module Api
  def self.main
    Rack::Builder.new do
      map '/seeds' do
        run ::Api::Seeds
      end

      map '/orders' do
        run ::Api::Orders
      end

      map '/employees' do
        run ::Api::Employees
      end

      map '/locations' do
        run ::Api::Locations
      end

      map '/places' do
        run ::Api::Places
      end

      map '/accounts' do
        run ::Api::Accounts
      end
    end
  end
end
