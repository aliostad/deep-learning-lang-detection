Calculator::Application.routes.draw do
  root :to => 'pages#home'
  resources :sessions

  namespace :admin do
    resources :carriers
    resources :costs
    resources :coverages
    resources :surcharges
    resources :users
    match '/' => 'users#dashboard', as: 'dashboard'
  end

  get '/carriers/destination_state' => 'carriers#destination_state'
  post '/carriers/calculate' => 'carriers#calculate', as: 'carrier_calculate'
  post '/costs/calculate' => 'costs#calculate', as: 'cost_calculate'

  get 'javascript-disabled' => 'pages#javascript'
  get 'login' => 'sessions#new', as: 'login'
  get 'logout' => 'sessions#destroy', as: 'logout'
  get 'branding' => 'pages#branding', as: 'branding'
end
