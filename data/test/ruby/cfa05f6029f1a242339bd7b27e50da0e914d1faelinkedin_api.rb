require "linkedin_api/version"
require 'faraday'
require 'active_support'
require 'active_support/core_ext'
require "linkedin_api/middleware/request/oauth2"
require "linkedin_api/middleware/request/format"
require "linkedin_api/middleware/response/json"
require "linkedin_api/middleware/response/raise_error"

require "linkedin_api/api/profile"
require "linkedin_api/api/groups"


require "linkedin_api/error"

require "linkedin_api/record"
require "linkedin_api/model/profile"
require "linkedin_api/model/group_membership"
require "linkedin_api/model/group"


require "linkedin_api/request/group_search"

require "linkedin_api/response/group_search"


require "linkedin_api/client"


module LinkedinApi

  Faraday::Request.register_middleware  :oauth2   => lambda { LinkedinApi::Middleware::Request::Oauth2 }, \
                                        :format => -> { LinkedinApi::Middleware::Request::Format }

  Faraday::Response.register_middleware :json => -> { LinkedinApi::Middleware::Response::Json}, \
                                        :raise_error => -> {LinkedinApi::Middleware::Response::RaiseError }


end
