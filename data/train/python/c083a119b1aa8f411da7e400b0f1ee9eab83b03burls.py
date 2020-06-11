#!/usr/bin/env python
# -*- coding: utf-8 -*-

from app.controllers import IndexController
from app.controllers import QController
from app.controllers import SettingsPartiesController
from app.controllers import SettingsTubiController
from app.controllers import StartController
from app.controllers.auth import LoginAuthorizedController
from app.controllers.auth import LoginController
from app.controllers.birri  import BirriController
from app.controllers.parties  import PartiesController
from app.controllers.parties  import SelectPartyController
from app.controllers.requests  import RequestsController
from app.controllers.tubi  import TubiController


URLS = (
    '/', IndexController,
    '/login', LoginController,
    '/login/authorized', LoginAuthorizedController,
    '/settings/parties', SettingsPartiesController,
    '/parties', PartiesController,
    '/parties/select', SelectPartyController,
    '/settings/tubi', SettingsTubiController,
    '/tubi', TubiController,
    '/birri', BirriController,
    '/start', StartController,
    '/q', QController,
    '/requests', RequestsController
)
