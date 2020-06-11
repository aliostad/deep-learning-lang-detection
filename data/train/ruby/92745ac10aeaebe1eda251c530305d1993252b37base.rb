require 'toggl_api/request'
require 'toggl_api/api/client'
require 'toggl_api/api/project'
require 'toggl_api/api/project_user'
require 'toggl_api/api/tag'
require 'toggl_api/api/task'
require 'toggl_api/api/time_entry'
require 'toggl_api/api/user'
require 'toggl_api/api/workspace'
require 'toggl_api/api/workspace_user'

module Toggl
  class Base

    include Toggl::Request
    include Toggl::Api::Client
    include Toggl::Api::Project
    include Toggl::Api::ProjectUser
    include Toggl::Api::Tag
    include Toggl::Api::Task
    include Toggl::Api::TimeEntry
    include Toggl::Api::User
    include Toggl::Api::Workspace
    include Toggl::Api::WorkspaceUser

    APIVERSION = "v8"

    def initialize(username, pass='api_token')
      @username,@pass = username,pass
    end

    private 

    def basic_path(path)
      path = "/api/#{APIVERSION}#{path}" unless path =~ /api/
    end

  end 
end
