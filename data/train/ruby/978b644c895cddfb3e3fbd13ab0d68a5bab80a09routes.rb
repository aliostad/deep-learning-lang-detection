A::Application.routes.draw do
  scope '/admin' do
    resources :articles
  end
  #get "controller#action"
  #match 'articles/:url' => 'articles#public', :as => :article
  #match '/home' => 'static#home', :as => :home
  get '/about' => 'static#about', :as => :about
  get '/contact' => 'static#contact', :as => :contact
  get '/trebovaniya' => 'static#trebovaniya', :as => :trebovaniya
  get '/vizitki' => 'static#vizitki', :as => :vizitki

  get '/silk' => 'static#silk', :as => :silk
  get '/printer' => 'static#printer', :as => :printer
  get '/tisnenie' => 'static#tisnenie', :as => :tisnenie
  get '/vyrubka' => 'static#vyrubka', :as => :vyrubka
  get '/lak' => 'static#lak', :as => :lak
  get '/upprint' => 'static#upprint', :as => :upprint
  get '/plasticfolders' => 'static#plasticfolders', :as => :plasticfolders
  get '/folders' => 'static#folders', :as => :folders
  get '/cards' => 'static#cards', :as => :cards
  
  #get '/plasticfolders' => 'static#plasticfolders', :as => :plasticfolders

  #temp blank stuff
  #match '/stickers' => 'static#index', :as => :stickers
  #end of temp blank stuff

  #resources :articles

  #resources :index

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "static#home" #"index#index"
  #map.connect '',:controller=>"index",:action=>"index"
  #get 'index/vizitki_calculate'
  match 'index/vizitki_calculate', to: 'index#vizitki_calculate', via: [:get, :post]
  match 'index/silk_calculate', to: 'index#silk_calculate', via: [:get, :post]
  #get 'index/silk_calculate' => 'index#silk_calculate'
  #beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
  match 'index/printer_calculate', to: 'index#printer_calculate', via: [:get, :post]
  match 'index/tisnenie_calculate', to: 'index#tisnenie_calculate', via: [:get, :post]
  match 'index/klishe_calculate', to: 'index#klishe_calculate', via: [:get, :post]
  match 'index/vyrubka_calculate', to: 'index#vyrubka_calculate', via: [:get, :post]
  match 'index/lak_calculate', to: 'index#lak_calculate', via: [:get, :post]
  match 'index/upprint_calculate', to: 'index#upprint_calculate', via: [:get, :post]
  match 'index/plasticfolders_calculate', to: 'index#plasticfolders_calculate', via: [:get, :post]
  match 'index/folders_calculate', to: 'index#folders_calculate', via: [:get, :post]
  match 'index/cards_calculate', to: 'index#cards_calculate', via: [:get, :post]

  #get 'index/printer_calculate'
  #get 'index/tisnenie_calculate'
  #get 'index/klishe_calculate'
  #get 'index/vyrubka_calculate'
  #get 'index/lak_calculate'
  #get 'index/upprint_calculate'
  #get 'index/plasticfolders_calculate'
  

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end