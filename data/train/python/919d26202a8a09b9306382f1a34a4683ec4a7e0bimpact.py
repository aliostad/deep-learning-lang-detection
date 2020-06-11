# -*- coding: utf-8 -*-

""" Impact - Controller

    @author: Michael Howden (michael@sahanafoundation.org)
    @date-created: 2010-10-12

"""

prefix = request.controller
resourcename = request.function

#==============================================================================
def type():

    """ RESTful CRUD controller """

    tablename = "%s_%s" % (prefix, resourcename)
    table = db[tablename]

    return s3_rest_controller(prefix, resourcename)


#==============================================================================
def impact():

    """ RESTful CRUD controller """

    tablename = "%s_%s" % (prefix, resourcename)
    table = db[tablename]

    return s3_rest_controller(prefix, resourcename)


#==============================================================================
