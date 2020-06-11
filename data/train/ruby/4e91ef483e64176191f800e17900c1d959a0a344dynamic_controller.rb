require 'ransack'
require 'kaminari'
require 'nql'

module DynamicController
  ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]
end

require 'dynamic_controller/version'
require 'dynamic_controller/resource'
require 'dynamic_controller/responder'
require 'dynamic_controller/helper_methods'
require 'dynamic_controller/class_methods'
require 'dynamic_controller/instance_methods'
require 'dynamic_controller/action_controller_extension'

ActionController::Base.send :extend, DynamicController::ActionControllerExtension

