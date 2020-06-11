module I10::ActionController
end

require 'i10/action_controller/convenience_methods'
require 'i10/action_controller/render_csv'
require 'i10/action_controller/render_rss'
require 'i10/action_controller/restful'
require 'i10/action_controller/restful_controller'
require 'i10/action_controller/template_inheritance'

# ActionController Extensions
ActionController::Base.class_eval do
  extend I10::ActionController::AuthenticatedController
  include I10::ActionController::ConvenienceMethods
  include I10::ActionController::RenderCsv
  include I10::ActionController::RenderRss
  include I10::ActionController::Restful
  extend I10::ActionController::RestfulController
  include I10::ActionController::TemplateInheritance
end
