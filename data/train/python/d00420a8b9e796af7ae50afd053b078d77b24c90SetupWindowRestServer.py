import threading, web

from Controllers.SetupWindowController import SetupWindowController

class ActionInterface(object):
    pass

class SetupWindowRestServer(threading.Thread, web.application):
    def __init__(self, controller, port = 8080):
        threading.Thread.__init__(self)
        web.application.__init__(self, SetupWindowController.routes, SetupWindowController.__dict__)
        self.port = port
        self.controller = controller
        SetupWindowController.setController(controller)
        self.daemon = True

    def run(self, *middleware):
        func = self.wsgifunc(*middleware)
        return web.httpserver.runsimple(func, ('0.0.0.0', self.port))

    def stop(self):
        pass