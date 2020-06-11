Rails.application.routes.draw do
  devise_for :admins

  devise_scope :admin do
  	get '/admins', to: 'devise/sessions#new'
  end

  resources :photoalbums do
    resources :photos #nested routes
  end

  resources :pages

  get 'process/new' => 'process#new'
  post 'process/new' => 'process#create'
  post 'process/check_person' => 'process#check_person'
  post 'process/create_person' => 'process#create_person'
  get 'process/get_pictures' => 'process#get_pictures'
  get '/pof' => 'pof#index'
  root 'pages#index'

 end
