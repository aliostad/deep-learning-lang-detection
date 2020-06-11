#$Id$

from projects.api.PortalsApi import PortalsApi
from projects.api.ProjectsApi import ProjectsApi
from projects.api.DashboardApi import DashboardApi
from projects.api.MilestonesApi import MilestonesApi
from projects.api.TaskListApi import TaskListApi
from projects.api.TasksApi import TasksApi
from projects.api.TimesheetsApi import TimesheetsApi
from projects.api.BugsApi import BugsApi
from projects.api.EventsApi import EventsApi
from projects.api.DocumentsApi import DocumentsApi
from projects.api.FoldersApi import FoldersApi
from projects.api.ForumsApi import ForumsApi
from projects.api.CategoryApi import CategoryApi
from projects.api.UsersApi import UsersApi

class ZohoProjects:
    """This class is used to create an object for projects service and to provide instance for all APIs."""
 
    def __init__(self, authtoken, portal_id=None):
        """Initialize parameters for zoho projects.

        Args:
            authtoken(str): User's Authtoken.
            portal_name(str): User's portal name.

        """
        self.authtoken = authtoken
        self.portal_id = portal_id

    def get_portals_api(self):
        """Get instance for portals api.

        Returns:
            instance: Portals api instance.
    
        """
        portals_api = PortalsApi(self.authtoken)
        return portals_api

    def get_projects_api(self):
        """Get instance for projects api.

        Returns:
            instance: Projects api instance.

        """
        projects_api = ProjectsApi(self.authtoken, self.portal_id)
        return projects_api

    def get_dashboard_api(self):
        """Get instance for dashboard api.
 
        Returns:
            instance: Dashboard api instance.
      
        """
        dashboard_api = DashboardApi(self.authtoken, self.portal_id)
        return dashboard_api
  
    def get_milestone_api(self):
        """Get instance for milestone api.

        Returns:
            instance: Milestone api instance.

        """
        milestone_api = MilestonesApi(self.authtoken, self.portal_id)
        return milestone_api

    def get_tasklist_api(self):
        """Get instance for tasklist api.
 
        Returns:
            instance: Tasklist api instance.

        """
        tasklist_api = TaskListApi(self.authtoken, self.portal_id)
        return tasklist_api

    def get_tasks_api(self):
        """Get instance for tasks api.

        Returns:
            instance: Tasks api instance.

        """
        tasks_api = TasksApi(self.authtoken, self.portal_id)
        return tasks_api

    def get_timesheets_api(self):
        """Get instance for timesheets api.

        Returns:
            instance: Timesheets api.

        """
        timesheets_api = TimesheetsApi(self.authtoken, self.portal_id)
        return timesheets_api

    def get_bugs_api(self):
        """Get instance for bugs api.

        Returns:
            instance: Bugs api.

        """
        bugs_api = BugsApi(self.authtoken, self.portal_id)
        return bugs_api
  
    def get_events_api(self):
        """Get instance for events api.

        Returns:
            instance: Events api.

        """
        events_api = EventsApi(self.authtoken, self.portal_id) 
        return events_api

    def get_documents_api(self):
        """Get instance for Documents api.

        Returns:
            instance: Documents api.
 
        """
        documents_api = DocumentsApi(self.authtoken, self.portal_id)
        return documents_api

    def get_folders_api(self):
        """Get instance for folders api.

        Returns: 
            instance: Folders api.

        """
        folders_api = FoldersApi(self.authtoken, self.portal_id)
        return folders_api

    def get_forums_api(self):
        """Get instance for forums api.

        Returns:
            instance: Forums api.

        """
        forums_api = ForumsApi(self.authtoken, self.portal_id)
        return forums_api

    def get_category_api(self):  
        """Get instance for category api.

        Returns: 
            instance: Category api.

        """
        category_api = CategoryApi(self.authtoken, self.portal_id)
        return category_api

    def get_users_api(self):  
        """Get instance for users api.

        Returns: 
            instance: Users api.

        """
        users_api = UsersApi(self.authtoken, self.portal_id)
        return users_api



