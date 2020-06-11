SubscriptionApi::Application.routes.draw do
  
   root 'api#index'

   get '/api/all_subscriptions' => "api#all_subscriptions"
   get '/api/get_subscription' => "api#get_subscription"
   get '/api/generate_error' => "api#generate_error"
 
   post '/api/login' => "api#login"
   get '/api/confirmation_email/:confirmation_hash' => "api#confirmation_email"


   post '/api/register_user' => "api#register_user"
   post '/api/add_subscription' => "api#add_subscription"
   post '/api/password_reset' => "api#password_reset"
  
end
