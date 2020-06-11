# -*- coding: utf-8 -*-
#
# Copyright 2010 LDLP (Laboratoire Départemental de Prehistoire du Lazaret)
# http://lazaret.unice.fr/opensource/ - opensource@lazaret.unice.fr
#
# This file is part of ArcheologicalAdressbook and is released under
# the GNU Affero General Public License 3 or any later version.
# See LICENSE.txt or <http://www.gnu.org/licenses/agpl.html>
#
""" `DbadminController` controller fonctional tests."""

from archeologicaladdressbook.tests import *


class TestDbadminController(TestController):
    """ Test the controller `DbmadminController`."""

    def test_01_routes(self):
        """ Test the routes of the `DbmadminController` controller."""
        self.app.get(url(controller='dbadmin'))
        self.app.get(url(controller='dbadmin', action='models'))

    def test_02_controller_denied_for_anonymous(self):
        """ Test than the `DbmadminController` controller is denied to anonymous."""
        # status 302 and not 401 because denied users are redirected to the main page
        self.app.get(url(controller='dbadmin', action='models'), status=302)

    def test_03_controller_denied_for_viewers(self):
        """ Test than the `DbmadminController` controller is denied for users with 'view' permission."""
        self.app.get(url(controller='dbadmin', action='models'),
            extra_environ={'repoze.what.credentials': self.guest},
            status=302)

    def test_04_controller_denied_for_editors(self):
        """ Test than the `DbmadminController` controller is denied to editors."""
        self.app.get(url(controller='dbadmin', action='models'),
            extra_environ={'repoze.what.credentials': self.editor},
            status=302)

    def test_05_controller_allowed_for_managers(self):
        """ Test than the `DbmadminController` controller is allowed for managers."""
        response = self.app.get(url(controller='dbadmin', action='models'),
            extra_environ={'repoze.what.credentials': self.manager},
            status=200)
        return response

    def test_06_response(self):
        """ Test response of the `DbmadminController` main page."""
        response = self.app.get(url(controller='dbadmin', action='models'),
            extra_environ={'repoze.what.credentials': self.manager})
        assert 'Models' in response

