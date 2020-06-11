## INFO ##
## INFO ##

# Import pygit2 modules
from pygit2 import (init_repository, discover_repository,
                    Repository,)

#------------------------------------------------------------------------------#
class Git:

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
    def __init__(self, location):
        #
        try:
            self._repo = Repository(discover_repository())
        except KeyError:
            self._repo = init_repository()


    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
    def update(self):
        pass


