require 'elocal_api_support/version'
require 'active_support/concern.rb'
require 'elocal_api_support/authorization'
require 'elocal_api_support/default_authorizer'
require 'elocal_api_support/enable_cors'
require 'elocal_api_support/model_from_params'
require 'elocal_api_support/actions'

module ElocalApiSupport
  module All
    extend ActiveSupport::Concern

    included do
      include ElocalApiSupport::Actions
      include ElocalApiSupport::Authorization
      include ElocalApiSupport::EnableCors
      include ElocalApiSupport::ModelFromParams
    end
  end
end
