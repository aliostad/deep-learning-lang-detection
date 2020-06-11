Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts, only: [:index, :create, :show, :update, :destroy] do
        resources :comments, only: [:index, :create]
      end
      resources :comments, only: [:index, :update, :destroy]
      resources :users, defaults: { format: :json }, only: [:show, :index, :create] do
        post 'sign_in', on: :collection
      end
    end
  end
end
#               Prefix Verb   URI Pattern                               Controller#Action
# api_v1_post_comments GET    /api/v1/posts/:post_id/comments(.:format) api/v1/comments#index
#                      POST   /api/v1/posts/:post_id/comments(.:format) api/v1/comments#create
#         api_v1_posts GET    /api/v1/posts(.:format)                   api/v1/posts#index
#                      POST   /api/v1/posts(.:format)                   api/v1/posts#create
#          api_v1_post GET    /api/v1/posts/:id(.:format)               api/v1/posts#show
#                      PATCH  /api/v1/posts/:id(.:format)               api/v1/posts#update
#                      PUT    /api/v1/posts/:id(.:format)               api/v1/posts#update
#                      DELETE /api/v1/posts/:id(.:format)               api/v1/posts#destroy
#      api_v1_comments GET    /api/v1/comments(.:format)                api/v1/comments#index
#       api_v1_comment PATCH  /api/v1/comments/:id(.:format)            api/v1/comments#update
#                      PUT    /api/v1/comments/:id(.:format)            api/v1/comments#update
#                      DELETE /api/v1/comments/:id(.:format)            api/v1/comments#destroy
# sign_in_api_v1_users POST   /api/v1/users/sign_in(.:format)           api/v1/users#sign_in {:format=>:json}
#         api_v1_users GET    /api/v1/users(.:format)                   api/v1/users#index {:format=>:json}
#                      POST   /api/v1/users(.:format)                   api/v1/users#create {:format=>:json}
#          api_v1_user GET    /api/v1/users/:id(.:format)               api/v1/users#show {:format=>:json}
