##########################################################################
# Copyright (C) 2009 - 2014 Huygens ING & Gerbrandy S.R.L.
#
# This file is part of bioport.
#
# bioport is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program.  If not, see
# <http://www.gnu.org/licenses/gpl-3.0.html>.
##########################################################################

# this directory is a package
from zope.i18nmessageid import MessageFactory
BioportMessageFactory = MessageFactory('bioport')


#
#  Provide a global utility for having one repository around
#

import grok
from bioport_repository.repository import Repository
from zope import interface

# repository = None


class IRepository(interface.Interface):
    """A marker interface for SiteRepository"""
    pass


class SiteRepository(grok.GlobalUtility):
    grok.implements(IRepository)
    grok.provides(IRepository)

    def __init__(self):
        pass

    def repository(self, data):
        """
        arguments:
            data must have properties that define the repository
        """
        try:
            return self._repository
        except AttributeError:
            self._repository = Repository(
                svn_repository=data.SVN_REPOSITORY,
                svn_repository_local_copy=data.SVN_REPOSITORY_LOCAL_COPY,
                dsn=data.DB_CONNECTION,
                images_cache_local=data.IMAGES_CACHE_LOCAL,
                images_cache_url=data.IMAGES_CACHE_URL,
            )
        return self._repository
