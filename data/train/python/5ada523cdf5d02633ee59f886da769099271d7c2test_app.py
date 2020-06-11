#!/usr/bin/env python
# -*- coding: utf-8 -*-

# wight load testing
# https://github.com/heynemann/wight

# Licensed under the MIT license:
# http://www.opensource.org/licenses/mit-license
# Copyright (c) 2013 Bernardo Heynemann heynemann@gmail.com

from preggy import expect

from wight.cli.app import WightApp
from wight.cli.default import SetDefaultController, GetDefaultController
from wight.cli.target import TargetSetController, TargetGetController
from wight.cli.auth import AuthController
from wight.cli.team import CreateTeamController, ShowTeamController, UpdateTeamController, TeamAddUserController, DeleteTeamController, TeamRemoveUserController
from wight.cli.project import CreateProjectController, UpdateProjectController, DeleteProjectController
from wight.cli.user import ShowUserController, ChangePasswordController
from wight.cli.load_test import ScheduleLoadTestController, ListLoadTestController, InstanceLoadTestController, ShowResultController
from tests.unit.base import TestCase


class TestWightApp(TestCase):
    app_class = WightApp

    def setUp(self):
        super(TestWightApp, self).setUp()
        self.reset_backend()
        self.app = WightApp(argv=[], config_files=[])

    def test_wight_app(self):
        self.app.setup()
        self.app.run()
        self.app.close()

    def test_has_proper_controllers(self):
        self.app.setup()

        self.app.register_controllers()

        expect(self.app.controllers).to_length(20)
        expect(self.app.controllers).to_include(TargetSetController)
        expect(self.app.controllers).to_include(TargetGetController)
        expect(self.app.controllers).to_include(AuthController)
        expect(self.app.controllers).to_include(CreateTeamController)
        expect(self.app.controllers).to_include(ShowTeamController)
        expect(self.app.controllers).to_include(UpdateTeamController)
        expect(self.app.controllers).to_include(DeleteTeamController)
        expect(self.app.controllers).to_include(ShowUserController)
        expect(self.app.controllers).to_include(TeamAddUserController)
        expect(self.app.controllers).to_include(TeamRemoveUserController)
        expect(self.app.controllers).to_include(CreateProjectController)
        expect(self.app.controllers).to_include(UpdateProjectController)
        expect(self.app.controllers).to_include(DeleteProjectController)
        expect(self.app.controllers).to_include(ChangePasswordController)
        expect(self.app.controllers).to_include(ScheduleLoadTestController)
        expect(self.app.controllers).to_include(ListLoadTestController)
        expect(self.app.controllers).to_include(InstanceLoadTestController)
        expect(self.app.controllers).to_include(ShowResultController)
        expect(self.app.controllers).to_include(SetDefaultController)
        expect(self.app.controllers).to_include(GetDefaultController)
