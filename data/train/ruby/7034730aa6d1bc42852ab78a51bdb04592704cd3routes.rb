SmartgraphsConnector::Engine.routes.draw do
  get '/persistence' => 'persistence#check'
  get '/persistence/:learner_id' => 'persistence#show', :constraints => {:learner_id => /\d+/}
  post '/persistence/:learner_id' => 'persistence#update', :constraints => {:learner_id => /\d+/}

  get '/manage/activities' => 'management#index', :as => 'manage_list'
  get '/manage/activity/:id' => 'management#activity', :as => 'manage_activity', :constraints => {:id => /\d+/}
  post '/manage/activity/:id' => 'management#publish', :as => 'publish_activity', :constraints => {:id => /\d+/}
end
