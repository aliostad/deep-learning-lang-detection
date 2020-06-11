Rails.application.routes.draw do
  get '/api/documentation/:major' => 'api#description'
  match '/api/:major/_methods/:method' => 'api#run_methods'
  get '/api/:major/:model/:record_id/:edge' => 'api#edge'
  post '/api/:major/:model/:record_id/:edge' => 'api#new_edge'
  get '/api/:major/:model' => 'api#index'
  post '/api/:major/:model' => 'api#create'
  get '/api/:major/:model/:record_id' => 'api#show'
  put '/api/:major/:model/:record_id' => 'api#update'
  delete '/api/:major/:model/:record_id' => 'api#destroy'
end
