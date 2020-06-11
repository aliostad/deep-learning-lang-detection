JquerySortableTreeTest::Application.routes.draw do
  get 'category/index'
  get 'category/manage'

  root to: 'welcome#index'

  resources :pages do
    collection do
      get :nested_options
      get :indented_options
      get :optgroup
      get :manage
      get :node_manage
      get :expand

      post :rebuild
      post :expand_node
    end
  end

  namespace :admin do
    resources :pages do
      collection do
        get  :nested_options, :indented_options, :optgroup, :manage, :node_manage
        post :rebuild
      end
    end
  end

  resources :article_categories do
    collection do
      get  :manage
      post :rebuild
    end
  end

  namespace :inventory do
    resources :categories do
      collection do
        get  :manage
        post :rebuild
      end
    end
  end
end
