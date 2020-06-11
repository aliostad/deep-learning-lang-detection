Phonebooth25::Application.routes.draw do
  resources :transcripts

    match 'api/ask_question', :controller => 'api', :action => 'ask_question'
    match 'api/save_transcript' , :controller => 'api', :action => 'save_transcript'
    match 'api/multicall' , :controller => 'api', :action => 'multicall'
    match 'api/ask', :controller => 'api', :action => 'ask', :conditions => {:method => :post}
    match 'api/ask2', :controller => 'api', :action => 'ask2', :conditions => {:method => :post}
    match 'api/ask3', :controller => 'api', :action => 'ask3', :conditions => {:method => :post}
    match 'api/outro', :controller => 'api', :action => 'outro', :conditions => {:method => :post}
    
end
