#!/usr/bin/env python
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#                                   Jiao Lin
#                      California Institute of Technology
#                        (C) 2006  All Rights Reserved
#
# {LicenseText}
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#


def controllers():
    from ControllerContainer import ControllerContainer
    controllers = ControllerContainer()
##     from HistogramListController import HistogramListController
##     hlc = HistogramListController( controllers )
##     controllers.set( "list", hlc )
    from MenuController import MenuController
    menucontroller = MenuController( models, controllers, view )
    controllers.set( "menu", menucontroller )
    return controllers


# version
__id__ = "$Id$"

# End of file 
