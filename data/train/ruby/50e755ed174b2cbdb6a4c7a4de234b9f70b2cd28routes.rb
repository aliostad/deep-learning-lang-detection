Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

 root to: 'home#index'

  resources :categories, only: [:index]
  resources :check_ins, :packages, :customers
  resources :user, only: [:edit, :update, :index]

  resources :packages do
    resource :check_ins
  end

   get 'settings/manage_customers' => 'settings#manage_customers'
   get 'settings/manage_packages' => 'settings#manage_packages'
   get 'settings/manage_checkins' => 'settings#manage_checkins'

  resources :settings, only: [:index]

  resources :admin, only: [:index]

  scope :api do
    get "/user(.:format)" => "user#index"
    get "/user/:id(.:format)" => "user#show"
    get "/user/:id/customer(.:format)" => "user#customer"
  end

end
