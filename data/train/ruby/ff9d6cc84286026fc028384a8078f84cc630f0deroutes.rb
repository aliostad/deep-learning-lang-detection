Phone::Application.routes.draw do
  root :to => 'home#index'
  devise_for :users
  resources :numbers
  resources :calls do
    member do
      get 'toggle_new'
    end
  end
  resources :contacts
  resources :scripts do
    resources :items
  end
  resources :mailboxes do
    resources :messages
  end
  match 'api' =>               'api#index'
  match 'api/call' =>          'api#call'
  match 'api/menu' =>          'api#menu'
  match 'api/info' =>          'api#info'
  match 'api/music' =>         'api#music'
  match 'api/music/songs' =>   'api#songs'
  match 'api/music/artists' => 'api#artists'
  match 'api/play' =>          'api#play'
  match 'api/message' =>       'api#message'
  match 'api/messages' =>      'api#messages'
  match 'api/mailbox' =>       'api#mailbox'
  resources :music
end
