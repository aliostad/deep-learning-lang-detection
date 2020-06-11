Reaper::Application.routes.draw do
 namespace :api do
    namespace :v1 do
            get '/album' => 'api#get_album'
      post '/album' => 'api#post_album'

      get '/artist' => 'api#get_artist'
      post '/artist' => 'api#post_artist'

      get '/customer' => 'api#get_customer'
      post '/customer' => 'api#post_customer'

      get '/employee' => 'api#get_employee'
      post '/employee' => 'api#post_employee'

      get '/genre' => 'api#get_genre'
      post '/genre' => 'api#post_genre'

      get '/invoice_line' => 'api#get_invoice_line'
      post '/invoice_line' => 'api#post_invoice_line'

      get '/invoice' => 'api#get_invoice'
      post '/invoice' => 'api#post_invoice'

      get '/media_type' => 'api#get_media_type'
      post '/media_type' => 'api#post_media_type'

      get '/playlist' => 'api#get_playlist'
      post '/playlist' => 'api#post_playlist'

      get '/track' => 'api#get_track'
      post '/track' => 'api#post_track'

    end
  end
end
