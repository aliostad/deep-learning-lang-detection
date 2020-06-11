#!/usr/bin/python
# -*- coding:utf-8 -*-


import tornado.ioloop
import tornado.web
from WebHandlers import *
import os
import sys

class WebView(object):
    def __init__(self, port=8888, secure_url="", controller = None):
        self.controller = controller
        if secure_url != "":
            self.secure_path="/%s" % secure_url
        else:
            self.secure_path=""
        self.port = port

    def add_controller(self, controller):
        self.controller = controller
        self.init_webapp()

    def init_webapp(self):
        settings = {
            'debug': False,
            'static_path': os.path.join(os.path.dirname(os.path.abspath(__file__)), 'static'),
        }
        handlers = [
                        (r"%s/index.html" % self.secure_path, DefaultHandler, dict(controller=self.controller)),
                        (r"%s/" % self.secure_path, DefaultHandler, dict(controller=self.controller)),
                        #(r"%s/.*"  % self.secure_path, DefaultHandler, dict(controller=self.controller)),
                        (r"%s/config/get/.*" % self.secure_path, GetConfigHandler, dict(controller=self.controller)),
                        (r"%s/config/set/.*" % self.secure_path, SetConfigHandler, dict(controller=self.controller)),
                        (r"%s/config/reload/.*" % self.secure_path, ReloadInterHandler, dict(controller=self.controller)),
                        (r"%s/inter/get/.*" % self.secure_path, GetInterHandler, dict(controller=self.controller)),
                        (r"%s/inter/set/.*" % self.secure_path, SetInterHandler, dict(controller=self.controller)),
                        (r'%s/static/(.*)' % self.secure_path, tornado.web.StaticFileHandler, dict(path=settings['static_path'])),
                        ("/.*", ErrorHandler, dict(controller=self.controller)),
                                             ]
        self.application = tornado.web.Application(handlers, **settings)
        self.application.listen(self.port)

    def start(self):
        print "Starting View"
        sys.stdout.flush()
        tornado.ioloop.IOLoop.instance().start()



if __name__ == '__main__':
    class Controller(object):
        def __init__(self):
            print "init"

        def get_inter(self, address, number):
            """
            :param address:
            :param number:
            :return:
            """
            return "Get : {} / {}".format(address, number)

        def set_inter(self, address, number, cmd):
            """
            :param address:
            :param number:
            :param cmd:
            :return:
            """
            return "Set {} : {} / {}".format(cmd, address, number)

    c = Controller()
    v = WebView(8080)
    v.add_controller(c)
    v.start()

