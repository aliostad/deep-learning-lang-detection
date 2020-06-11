#! /usr/bin/env python
import os
import tornado.ioloop
import tornado.options
from tornado.options import define, options
import tornado.web

from api.controller.BaseStaticFileHandler import BaseStaticFileHandler

from api.controller.ServerListController import ServerListController
from api.controller.InfoController import InfoController
from api.controller.CommandsController import CommandsController
from api.controller.InfoListController import InfoListController
from api.controller.StatusController import  StatusController
from api.controller.SettingsController import SettingsController
from api.controller.SlowlogController import SlowlogController
from daemonized import daemonized

class redis_live(daemonized):
    def run_daemon(self):

        define("port", default=8888, help="run on the given port", type=int)
        define("debug", default=0, help="debug mode", type=int)
        tornado.options.parse_command_line()
        
        print os.path.abspath('.')
        # Bootup
        handlers = [
        (r"/api/servers", ServerListController),
        (r"/api/info", InfoController),
        (r"/api/status", StatusController),
         (r"/api/infolist",InfoListController),
        (r"/api/commands", CommandsController),
        (r"/api/settings",SettingsController),
        (r"/api/slowlog",SlowlogController),
        (r"/(.*)", BaseStaticFileHandler, {"path": os.path.abspath('.')+'/www'})
        ]
    
        server_settings = {'debug': options.debug}
        application = tornado.web.Application(handlers, **server_settings)
        application.listen(options.port)
        tornado.ioloop.IOLoop.instance().start()

if __name__ == "__main__":
    live= redis_live()
    live.start()
    