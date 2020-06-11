class Api::BaseController < ActionController::Metal
  
  abstract!
  
  include AbstractController::Callbacks
  #include ActionController::Helpers
  #helper :all # By default, all helpers should be included
               
  #include ActionController::UrlFor
  #include ActionController::Redirecting
  include ActionController::Rendering
  include ActionController::Renderers::All
  #include ActionController::ConditionalGet
  include ActionController::Head
  include ActionController::RackDelegation
  include ActionController::MimeResponds
  
  
  
end
