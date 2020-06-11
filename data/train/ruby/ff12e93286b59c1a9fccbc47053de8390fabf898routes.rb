SchoolOfKorea::Application.routes.draw do
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  
  root :to => "main#home"
  
  match "/api/demo" => "api#demo", :as => "demo"
  match "/api/search" => "api#search"

  match "/api/school" => "api#school"
  match "/api/address" => "api#address"
  match "/api/document" => "api#document"
  resources :registrations, :only => [:create]
  match "/registrations/auth" => "registrations#auth"


  post "/api/snu_oauth" => "api#snu_oauth"
end
