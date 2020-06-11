SchoolBlog::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => :registrations }
  resources :users do
    member do
      get :user_info
      put :set_role
      post :set_role
    end
  end

  resources :posts do
    collection do
      get :autocomplete_search
    end
    resources :comments do
      member do
        post :modify
        post :edit
        put  :edit
      end
    end
  end

  match '/school_news' => 'users#school_news', :as => "school_news"
  match '/manage_posts' => 'users#manage_posts', :as => "manage_posts"
  match '/manage_comments' => 'users#manage_comments', :as => "manage_comments"
  match '/sort_by_comments' => 'users#sort_by_comments', :as => "sort_by_comments"
  root :to => "users#all_posts"
end
