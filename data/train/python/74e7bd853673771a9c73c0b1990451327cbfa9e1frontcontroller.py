#!/usr/bin/env python
#-*-coding:utf8-*-

class Dispatcher(object):
    module = controller = action = "default"
    is_dispatched = False

    def __init__(self, controlled):
        self.controlled = controlled

    def _dispatch(self):
        if self.is_dispatched == False:
            controller_file = 'modules.%s.controllers.%s' % (self.module, self.controller)
            controller = __import__(controller_file, fromlist=['modules'])
            print controller
            controller_instance = controller.Instance(self.controlled)
            is_dispatched = True
            return eval('controller_instance.%s_action()' % self.action)

    def get_instance(self):
        return self._dispatch()
