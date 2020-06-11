Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :products do
  	get "delete"
  end

  resources :photos

  controller :api do
  	get '/api/product_list' => "api#index"
  	get '/api/view_product' => "api#show"
  	put '/api/update_product' => "api#update"
  	post '/api/create_product' => 'api#create'
  	delete '/api/delete_product' => 'api#destroy'

    post 'api/login' => 'api#login'
    post 'api/create_user' => "api#create_user"
    delete 'api/sign_out' => "api#signout"
  end



  root to: 'products#index'





end
