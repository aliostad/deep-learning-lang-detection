$: << File.expand_path(File.dirname(__FILE__))

require 'active_support/inflector'
ActiveSupport::Inflector.inflections do |inflector|
  inflector.singular 'status', 'status'
end

require 'jira_rest_api/base'
require 'jira_rest_api/base_factory'
require 'jira_rest_api/has_many_proxy'
require 'jira_rest_api/http_error'

require 'jira_rest_api/resource/user'
require 'jira_rest_api/resource/attachment'
require 'jira_rest_api/resource/component'
require 'jira_rest_api/resource/issuetype'
require 'jira_rest_api/resource/version'
require 'jira_rest_api/resource/status'
require 'jira_rest_api/resource/transition'
require 'jira_rest_api/resource/project'
require 'jira_rest_api/resource/priority'
require 'jira_rest_api/resource/comment'
require 'jira_rest_api/resource/worklog'
require 'jira_rest_api/resource/issue'
require 'jira_rest_api/resource/filter'

require 'jira_rest_api/request_client'
require 'jira_rest_api/oauth_client'
require 'jira_rest_api/http_client'
require 'jira_rest_api/client'

require 'jira_rest_api/railtie' if defined?(Rails)
