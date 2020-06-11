"""
Homepage module .

This module provides the implementation of qsos repository site's root
"""
##
#    @defgroup  homepage Homepage
#    @ingroup Services
#    @author Hery Randriamanamihaga

from twisted.application import service, internet

from nevow               import appserver
from nevow               import rend
from nevow               import loaders
from nevow               import tags as T
from nevow               import inevow
from nevow  import static

import browse
import submit
from QSOSpage import QSOSPage
from Engine import core


##
#    @ingroup homepage
#
class MainPage ( QSOSPage ):
    """
    Handles site's main page
    
    This class handles qsos repository home page.
    """
        
    def makeDocFactory(self) :
        core.setup(self.repository)
        return loaders.stan (
        T.html [ self.render_Head,
                 T.body [ T.h1 [ "This is the QSOS Repository [" + self.repository + "] Main Page" ],
                          T.p ["For now, you can ",
                               T.a ( href = 'repository' ) [ "browse" ],
                               " the repository or ",
                               T.a ( href = 'submit' ) [ "submit" ],
                               " an evaluation. "
                                ]
                 ],
               ]
        )
    
    def childFactory ( self, ctx, name ):
        if name == 'repository' :
            return browse.MainPage(self.repository)
        elif name == 'submit' :
            return submit.UploadPage(self.repository)
        else :
            return None
        