#!/usr/bin/env python
# -*- coding: utf-8 -*-

# wight load testing
# https://github.com/heynemann/wight

# Licensed under the MIT license:
# http://www.opensource.org/licenses/mit-license
# Copyright (c) 2013 Bernardo Heynemann heynemann@gmail.com

from cement.core import foundation, handler
from colorama import init

from wight.cli.base import WightDefaultController
from wight.cli.auth import AuthController
from wight.cli.default import SetDefaultController, GetDefaultController
from wight.cli.target import TargetSetController, TargetGetController
from wight.cli.team import CreateTeamController, ShowTeamController, UpdateTeamController, TeamAddUserController, DeleteTeamController, TeamRemoveUserController
from wight.cli.project import CreateProjectController, UpdateProjectController, DeleteProjectController
from wight.cli.user import ShowUserController, ChangePasswordController
from wight.cli.load_test import ScheduleLoadTestController, ListLoadTestController, InstanceLoadTestController, ShowResultController
from wight.models import UserData


class WightApp(foundation.CementApp):
    class Meta:
        label = 'wight'
        base_controller = WightDefaultController

    def __init__(self, label=None, **kw):
        super(WightApp, self).__init__(**kw)
        self.user_data = UserData.load()
        init(autoreset=True)

    def register_controllers(self):
        self.controllers = [
            AuthController,
            TargetSetController,
            TargetGetController,
            CreateTeamController,
            UpdateTeamController,
            ShowTeamController,
            DeleteTeamController,
            ShowUserController,
            TeamAddUserController,
            CreateProjectController,
            UpdateProjectController,
            DeleteProjectController,
            TeamRemoveUserController,
            ChangePasswordController,
            ScheduleLoadTestController,
            ListLoadTestController,
            InstanceLoadTestController,
            ShowResultController,
            SetDefaultController,
            GetDefaultController,
        ]

        for controller in self.controllers:
            handler.register(controller)
