Fakebook::Application.routes.draw do

  root :to => 'posts#index'
  devise_for :users , :controllers => {:registrations => "registrations"}
  resources :admins, :as => :users
  resources :posts
  resources :comments,        :only => [:create, :destroy]
  resources :find_friends,    :only => [:index]
  resources :friendships ,     :only => [:new,:update, :destroy, :index]

  controller :admins do
    match 'manage_users', :to => 'admins#manage_users', :as => :manage_users
    match 'manage_users/edit/:id' => :edit, :as => :edit_manage_users

    match 'manage_posts', :to => 'admins#manage_posts', :as => :manage_posts
    match 'manage_posts/edit/:id' => :edit, :as => :edit_manage_posts

    match 'manage_comments', :to => 'admins#manage_comments', :as => :manage_comments
    match 'manage_comments/edit/:id' => :edit, :as => :edit_manage_comments

    # match "/:firstname(.:lastname)" => 'posts#show', :as => :profile
    match "/:username" => 'posts#show', :as => :profile
  end



end
