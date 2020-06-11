module Knome
  module API
    module V1
      class API_v1 < Grape::API

        # Prevent Stacktrace from being sent
        if Rails.env.production?
          rescue_from :all do |e|
            Rack::Response.new([ "Error" ], 500, { "Content-type" => "text/error" }).finish
          end
        end

        # Mount
        # /api/v1/answers
        mount ::Knome::API::V1::Answers
        # /api/v1/blogposts
        mount ::Knome::API::V1::Blogposts
        # /api/v1/comments
        mount ::Knome::API::V1::Comments
        # /api/v1/communities
        mount ::Knome::API::V1::Communities
         # /api/v1/microblogs
        mount ::Knome::API::V1::Microblogs
        # /api/v1/messages
        mount ::Knome::API::V1::Messages
        # /api/v1/questions
        mount ::Knome::API::V1::Questions
        # /api/v1/timelines
        mount ::Knome::API::V1::Timelines
        # /api/v1/users
        mount ::Knome::API::V1::Users
        # /api/v1/views
        mount ::Knome::API::V1::Views
        # /api/v1/votes
        mount ::Knome::API::V1::Votes
        # /api/v1/follows
        mount ::Knome::API::V1::Follows
        # /api/v1/favorites
        mount ::Knome::API::V1::Favorites
        # /api/v1/related
        mount ::Knome::API::V1::Related
        # /api/v1/shares
        mount ::Knome::API::V1::Shares
      end
    end
  end
end