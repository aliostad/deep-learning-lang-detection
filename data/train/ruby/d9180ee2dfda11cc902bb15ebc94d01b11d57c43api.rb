require_relative 'sessions_api'
require_relative 'users_api'
require_relative 'shops_api'
require_relative 'products_api'
require_relative 'shop_products_api'
require_relative 'reviews_api'
require_relative 'search_api'
require_relative 'favorites_api'
require_relative 'managements_api'
require_relative 'suggestions_api'
require_relative 'managers_api'
require_relative 'promotions_api'
require_relative 'notifications_api'
require_relative 'messages_api'
require_relative 'orders_api'
require 'rabl'

module API
  class RablPresenter
    def self.represent(object, options)
      render_options = {
        :format => :json,
        :view_path => Rails.root.join('app/views')
      }
      Rabl::Renderer.new(options[:source], object, render_options).render
    end
  end

  class AppAPI < Grape::API
    version 'v1'
    format :json
    prefix "api"

    helpers do
      def current_user
        @current_user ||= User.find_for_authentication(:authentication_token => params[:auth_token])
      end

      def authenticate!
        error!({message: '401 Unauthorized'}.to_json, 401) unless current_user
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      Rack::Response.new([ e.message ], 500, { "Content-type" => "text/error" }).finish
    end

    mount API::Sessions
    mount API::Users
    mount API::Shops
    mount API::ShopProducts
    mount API::Products
    mount API::Reviews
    mount API::Search
    mount API::Favorites
    mount API::Managements
    mount API::Suggestions
    mount API::Managers
    mount API::Promotions
    mount API::Notifications
    mount API::Messages
    mount API::Orders
  end
end
