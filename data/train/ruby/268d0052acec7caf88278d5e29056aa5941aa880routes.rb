# == Route Map
#
#         Prefix Verb   URI Pattern                    Controller#Action
#           root GET    /                              home#index
#     api_movies GET    /api/movies(.:format)          api/movies#index
#                POST   /api/movies(.:format)          api/movies#create
#  new_api_movie GET    /api/movies/new(.:format)      api/movies#new
# edit_api_movie GET    /api/movies/:id/edit(.:format) api/movies#edit
#      api_movie GET    /api/movies/:id(.:format)      api/movies#show
#                PATCH  /api/movies/:id(.:format)      api/movies#update
#                PUT    /api/movies/:id(.:format)      api/movies#update
#                DELETE /api/movies/:id(.:format)      api/movies#destroy
#                GET    /*unmatched_route(.:format)    home#index
#

Rails.application.routes.draw do
  root 'home#index'

  namespace :api do
    resources :movies
  end

  # leave this as last route at the bottom!
  get '*unmatched_route', to: 'home#index'
end
