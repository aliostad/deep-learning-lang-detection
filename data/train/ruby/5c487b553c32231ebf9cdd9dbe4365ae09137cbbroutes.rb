GitPhysicalApp::Application.routes.draw do
  root to: 'welcome#index'
  namespace :api do
    resources :exercises
  end

end

# == Route Map (Updated 2013-12-03 17:28)
#
#              root        /                                 welcome#index
#     api_exercises GET    /api/exercises(.:format)          api/exercises#index
#                   POST   /api/exercises(.:format)          api/exercises#create
#  new_api_exercise GET    /api/exercises/new(.:format)      api/exercises#new
# edit_api_exercise GET    /api/exercises/:id/edit(.:format) api/exercises#edit
#      api_exercise GET    /api/exercises/:id(.:format)      api/exercises#show
#                   PUT    /api/exercises/:id(.:format)      api/exercises#update
#                   DELETE /api/exercises/:id(.:format)      api/exercises#destroy
#

