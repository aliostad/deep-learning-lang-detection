require_relative '../hippo'
require_relative 'api/to_json'
require_relative 'api/request_wrapper'
require_relative 'api/error_formatter'
require_relative 'api/formatted_reply'
require_relative 'api/controller_base'
require_relative 'api/generic_controller'
require_relative 'api/cable'
require_relative 'api/sprockets_extension'
require_relative 'api/helper_methods'
require_relative 'api/cable'
require_relative 'api/pub_sub'
require_rel      'api/handlers/*.rb'
require_relative 'api/route_set'
require_relative "api/authentication_provider"
require_relative 'api/tenant_domain_router'
require_relative 'api/root'

module Hippo

    module API
        mattr_accessor :webpack
    end

end
