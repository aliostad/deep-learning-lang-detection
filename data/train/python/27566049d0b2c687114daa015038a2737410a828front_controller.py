# !/usr/bin/env python
# -*-coding:utf8 -*-

"""
Front controller
"""

class Dispatcher(object):
    frontcontroller = None
    module = "default"
    controller = "default"
    action = "index"
    isDispatched = False

    def __init__(self, frontcontroller):
        """
        """
        self.frontcontroller = frontcontroller

    def dispatch(self):
        if self.isDispatched == False:
            controllerFile = "modules.%s.controllers.%s" % (self.module,
                    self.controller)
            controller = __import__(controllerFile)
            controller = controller.getInstance()
            eval("controller.%s.Action()" % self.action)


def getInstance(frontcontroller):
    return Dispatcher(frontcontroller)
