Examples::Application.routes.draw do

  resources :clocks
  # post "clocks/new"

  # # post "clocks/create"


  # match "/clocks/:id" => "clocks#show"
  # # get "clocks/edit"

  # # get "clocks/delete"

  # match '/clocks/index' => "clocks#index"

  match "/bad_calculate" => "BadCalculations#calculate"
  match "/calculate" => "Calculations#calculate"
  match "/calculate_better" => "Calculations#calculate_better"
  
  

  resources :calculations, :bad_calculations
  
  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

end
