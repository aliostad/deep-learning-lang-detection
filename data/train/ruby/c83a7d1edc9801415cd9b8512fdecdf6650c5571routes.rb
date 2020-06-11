SpineRails3::Application.routes.draw do
  devise_for :users
  devise_for :users do
    get 'logout' => 'devise/sessions#destroy'
  end
 
  resources :pages
  
  root :to => 'pages#index'

  match 'api/get_user_role' => 'api#get_user_role'
  match 'api/users' => 'api#users'
  match 'api/logs' => 'api#logs'
  match 'api/cards' => 'api#cards'  
  match 'api/company_names' => 'api#get_company_name'
  match 'api/company_names/:name' => 'api#set_company_name', :via => :put
  
  match 'api/devices' => 'api#get_device', 		:via => :get
  match 'api/devices' => 'api#delete_device', 	:via => :delete
  match 'api/devices' => 'api#update_device', 	:via => :put
  match 'api/devices' => 'api#update_device', 	:via => :put
  
  match 'api/new_page' => 'api#new_page'

  match 'api/get_hash/:hash' => 'api#get_hash', :via => :get
  match 'api/set_hash' => 'api#set_hash', :via => :post
  
  match 'api/user_activate/:id/:enter' => 'api#user_activate', :via => :get
end
