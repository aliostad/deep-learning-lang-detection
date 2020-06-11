"""
Created on Aug 30, 2009

@author: kenny
"""

class BaseCommand(object):
    """
        
    """

    def __init__(self):
        '''
        Constructor for base command class
        '''
    @staticmethod
    def execute(str_cmd):
        """
            join all string commands received and output a ready
            to execute command
        """
        return "; ".join(str_cmd)

    @staticmethod
    def get_args(*args):
        """return sent args separated by space"""
        return " ".join(args)

class OnPathCommand(BaseCommand):
    """
        
    """
    def __init__(self):
        self._path = None
        super(OnPathCommand, self).__init__()

    @property
    def path(self):
        """Getter for path variable"""
        return self._path

    @path.setter
    def path(self, value):
        """Setter for path variable"""
        self._path = value

    def clear_path(self):
        """set path to None"""
        self._path = None

    def chdir(self, path = ""):
        """Change directory
        
        Command:
            cd %s
            
        path -- change to this directory or the one set on path
        """
        return 'cd %s' % (path or self._path)

class RepositoryCommands(OnPathCommand):

    def __init__(self, repository = ""):
        """
        Constructor.
        
        repository -- repository address
        """
        self._repository = repository
        super(RepositoryCommands, self).__init__()

    @property
    def repository(self):
        """Getter for repository variable"""
        return self._repository

    @repository.setter
    def repository(self, repo):
        """Setter for repository variable"""
        self._repository = repo

    def _get_repo(self, repo = ""):
        """Return the selected repository
        
        repo -- path to repository. if not set, self.repository is used
        """
        if not (repo or self.repository):
            raise RepositoryIsMissing
        if repo:
            return repo
        return self.repository

class RepositoryIsMissing(Exception):
    """This class represents a custom exception raised when a repository 
    is not set
    """
    pass