module Knome
  module API
    module V2
      class API_v2 < Grape::API

        # Prevent Stacktrace from being sent
        if Rails.env.production?
          rescue_from :all do |e|
            Rails.logger.error("Api Error: #{e.message}\n #{e.backtrace} ")
            Rack::Response.new([ "Error" ], 500, { "Content-type" => "text/error" }).finish
          end
        end

        # Mount
        # /api/v2/answers
        mount ::Knome::API::V2::Answers
        # /api/v2/blogposts
        mount ::Knome::API::V2::Blogposts
        # /api/v2/comments
        mount ::Knome::API::V2::Comments
        # /api/v2/communities
        mount ::Knome::API::V2::Communities
        # /api/v2/conversations
        mount ::Knome::API::V2::ConversationsApi
        # /api/v2/microblogs
        mount ::Knome::API::V2::Microblogs
        # /api/v2/messages
        # /api/v2/questions
        mount ::Knome::API::V2::Questions
        # /api/v2/timelines
        mount ::Knome::API::V2::Timelines
        # /api/v2/users
        mount ::Knome::API::V2::Users
        # /api/v2/views
        mount ::Knome::API::V2::Views
        # /api/v2/votes
        mount ::Knome::API::V2::Votes
        # /api/v2/wikis
        mount ::Knome::API::V2::WikiSections
        # /api/v2/follows
        mount ::Knome::API::V2::Follows
        # /api/v2/favorites
        mount ::Knome::API::V2::Favorites
        # /api/v2/related
        # /api/v2/shares
        mount ::Knome::API::V2::Shares
        # /api/v2/ideas
        mount ::Knome::API::V2::Ideas
        # /api/v2/challenges
        mount ::Knome::API::V2::Challenges
        # /api/v2/spheres
        mount ::Knome::API::V2::Spheres
        # /api/v2/:kso
        mount ::Knome::API::V2::UsersWhoInteracted
      end
    end
  end
end
