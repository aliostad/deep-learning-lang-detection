#!/usr/bin/env python
# -*- coding: utf-8 -*-


import falcon

from api import configure
from api import service
from api import tinywebserver

api = application = falcon.API()

api.add_route('/services', service.Collection())
api.add_route('/services/{service}', service.Item())
api.add_route('/services/{service}/configures', configure.Collection())
api.add_route('/services/{service}/configures/{configure}', configure.Item())

api.add_route('/', tinywebserver.DefaultPage())

static_file_handler = tinywebserver.StaticFiles()
api.add_sink(static_file_handler.on_get, '/static/')
