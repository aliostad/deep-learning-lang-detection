module ApiBuddy
end

require 'active_support/all'

require 'api_buddy/version'

require 'api_buddy/dsl'
require 'api_buddy/dsl/definition_builder'
require 'api_buddy/dsl/endpoint_builder'
require 'api_buddy/dsl/nested_object_builder'

require 'api_buddy/documenter'
require 'api_buddy/documenter/base_documenter'
require 'api_buddy/documenter/attribute_documenter'
require 'api_buddy/documenter/endpoint_documenter'
require 'api_buddy/documenter/definition_documenter'

require 'api_buddy/model'
require 'api_buddy/model/concerns/has_type'
require 'api_buddy/model/attribute'
require 'api_buddy/model/definition'
require 'api_buddy/model/endpoint'
require 'api_buddy/model/nested_object'
