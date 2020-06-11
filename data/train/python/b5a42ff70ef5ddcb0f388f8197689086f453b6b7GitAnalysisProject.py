'''
Project container wrapping git version control
'''
from zope.interface import implements

import Interfaces.AnalysisProject as pc
import FilesystemInteraction.GitDataRepository as git_repo
import FilesystemInteraction.INIDataRepository as ini_repo

import os

class GitAnalysisProject(object):
    '''
    This project controller creates a git repository to store project files
    and their changes, and reads/writes to a plain-text (ini) configuration
    file within that repository to indicate settings in use.
    '''
    
    implements(pc.IAnalysisProject)
    
    identifier = None # project directory
    
    settings_repository = ini_repo.INIDataRepository()
    file_repository = git_repo.GitDataRepository()
    
    def create_project(self, project_identifier, settings_source=None):
        """
        Create new project container.
        
        Initializes a git repo into the given directory (assumed to not exist).
        Creates a new settings ini called "project_settings.ini" in that directory.
        Creates a new log file called "project_history.txt" in that directory.
        """
        print "Creating a new project at \"%s\"..."%project_identifier
        
        proj_dir = os.path.abspath(project_identifier)
        try:
            os.stat(proj_dir)
        except:
            os.mkdir(proj_dir)
            
        self.identifier = project_identifier
        
        self.settings_repository.create_repository(project_identifier + "/project_settings.cfg")
        self.file_repository.create_repository(project_identifier)
        
        self.load_default_settings(settings_source)
        
        self.save_project()
        
    def open_project(self, project_identifier):
        """Point internal project reference to existing project"""
        self.identifier = project_identifier
        
        print "Using project at \"%s\"..."%project_identifier
        proj_dir = os.path.abspath(project_identifier)
        
        try:
            os.stat(proj_dir)
        except:
            print "No project directory found at %s"
            return
        
        self.settings_repository.open_repository(project_identifier + "/project_settings.cfg")
        self.file_repository.open_repository(project_identifier)
        
        # Todo: remove me; this is printing the available settings for debugging.
        for s in self.settings_repository.get_available_items():
            print s
        
    def save_project(self):
        '''
        Saves each project repository.
        '''
        self.settings_repository.save_repository()
        self.file_repository.save_repository()
        
    def close_project(self):
        '''
        Closes project repositories.
        '''
        self.file_repository.close_repository()
        self.settings_repository.close_repository()
    
    def load_default_settings(self, settings_source=None):
        """
        Load in settings from a local config file.
        (This assumes INIDataRepository use.)
        
        If not explicitly provided, looks in
        os.getcwd() + "/settings/"
                    + self.__class__.__name__
                    +"_default_settings.cfg"
        E.g. ./settings/SifterAnalysisProject_default_settings.cfg
        """
        if settings_source is None:
            settings_source = os.getcwd() + "/settings/" + \
                              self.__class__.__name__ + \
                              "_default_settings.cfg"
        
        defaults_repo = ini_repo.INIDataRepository()
        defaults_repo.open_repository(settings_source)
        
        for [item_ind, item_val] in defaults_repo.get_available_items(None):
            self.settings_repository.create_item(item_ind, item_val)
        
        defaults_repo.close_repository()