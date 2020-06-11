class Eventifier::API < Sliver::API
  def initialize
    super do |api|
      api.connect :get,  '/notifications', Eventifier::API::GetNotifications
      api.connect :post, '/notifications/touch',
        Eventifier::API::TouchNotifications

      api.connect :get, '/preferences', Eventifier::API::GetPreferences
      api.connect :put, '/preferences', Eventifier::API::PutPreferences
    end
  end
end

require 'eventifier/api/base'
require 'eventifier/api/view'
require 'eventifier/api/get_notifications'
require 'eventifier/api/touch_notifications'
require 'eventifier/api/get_preferences'
require 'eventifier/api/put_preferences'
