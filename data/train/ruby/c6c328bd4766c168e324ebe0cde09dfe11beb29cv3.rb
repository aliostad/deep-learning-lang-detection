module Api
  class V3 < Grape::API
    use Rack::ConditionalGet
    use Rack::ETag

    include API::Guard
    include API::CommonHelpers

    version 'v3', :using => :header, :vendor => 'revibe'
    format :json

    get '/' do
      guard!
      "Welcome to te Revibe API ver.3, #{current_user.username}"
    end

    mount Api::V3::Users
    mount Api::V3::Likes
    mount Api::V3::Playlists
    mount Api::V3::Tracks
    mount Api::V3::Searches
    mount Api::V3::Subscriptions
    mount Api::V3::NewsPosts
    mount Api::V3::Activities
    mount Api::V3::Radio
    add_swagger_documentation base_path: '/api'
  end
end

