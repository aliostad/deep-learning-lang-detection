require 'rails/all'
require 'restful_controller/action_controller/base'

require 'restful_controller/base'
require 'restful_controller/filters'
require 'restful_controller/helpers'
require 'restful_controller/version'

module RestfulController
  module Actions
    autoload :Show, 'restful_controller/actions/show'
    autoload :Index, 'restful_controller/actions/index'
    autoload :New, 'restful_controller/actions/new'
    autoload :Edit, 'restful_controller/actions/edit'
    autoload :Update, 'restful_controller/actions/update'
    autoload :Destroy, 'restful_controller/actions/destroy'
    autoload :Create, 'restful_controller/actions/create'
  end
end