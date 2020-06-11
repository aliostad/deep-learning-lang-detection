#  $Id$ 
require "zohoProjects/version"
require "projects/api/PortalAPI"
require 'projects/api/ProjectsAPI'
require 'projects/api/MilestonesAPI'
require 'projects/api/TasklistsAPI'
require 'projects/api/TasksAPI'
require 'projects/api/TimesheetsAPI'
require 'projects/api/FoldersAPI'
require 'projects/api/DocumentsAPI'
require 'projects/api/EventsAPI'
require 'projects/api/BugsAPI'
require 'projects/api/ForumsAPI'
require 'projects/api/UsersAPI'
require 'projects/model/Project'
require 'projects/model/Activity'
require 'projects/model/Milestone'
require 'projects/model/Tasklist'
require 'projects/model/Customfield'
require 'projects/model/Defaultfield'
require 'projects/model/Task'
require 'projects/model/Owner'
require 'projects/model/Bug'
require 'projects/model/Event'
require 'projects/model/Document'
require 'projects/model/Forum'
require 'projects/model/Category'
require 'projects/exception/ProjectsException'
require 'projects/service/ZohoProject'
include Projects::Api
include Projects::Pexception
include Projects::Model
include Projects::Service

module ZohoProjects

end
