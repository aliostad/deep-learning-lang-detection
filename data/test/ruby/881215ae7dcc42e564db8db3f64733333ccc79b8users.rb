module Engine
  module Apis

    class Users < Grape::API
      version 'v2', using: :accept_version_header

      content_type :json, "application/json;charset=UTF-8"
      format :json
      formatter :json, Grape::Formatter::Jbuilder

      mount ::HomeApi

      mount ::SignupApi
      mount ::LoginApi
      mount ::ForgotApi
      mount ::UsersApi
      mount ::TokensApi
      mount ::SettingsApi
      mount ::AddressesApi
      mount ::CouponsApi

      mount ::FeedsApi
      mount ::GroupsApi
      mount ::PostsApi
      mount ::CommentsApi

      mount ::SearchApi
      mount ::RefreshTokenApi

      mount ::CategoriesApi
      mount ::ProjectsApi
      mount ::OrdersApi
      mount ::TransactionsApi
      mount ::TicketsApi
      mount ::SupportsApi

      mount ::MessagesApi
      mount ::NotificationsApi
      mount ::SystemApi

      mount ::ReviewsApi
      mount ::PointsApi




    end
  end
end
