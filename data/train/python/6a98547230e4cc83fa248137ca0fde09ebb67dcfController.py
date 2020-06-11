import SimpleXMLRPCServer
import sys

import logging
from K8055Controller import K8055Controller

logging.basicConfig()

controller_log = logging.getLogger("Controller")

class Controller:
    def __init__(self):
        self.k8055 = K8055Controller()
        controller_log.debug("initialized")
        
    def reset(self):
        self.k8055.reset()
        controller_log.debug("reset")
        return 0
    
    def turn_on(self, i):
        self.k8055.turn_on(i)
        controller_log.debug('turned on %i' % (i))
        return 0
    
    def turn_off(self, i):
        self.k8055.turn_off(i)
        controller_log.debug('turned off %i' % (i))
        return 0
    
    def set_analog(self, i, level):
        if (i == 1):
            self.k8055.set_analog1(level)
        else:
            self.k8055.set_analog2(level)
        return 0

controller = Controller()        
server = SimpleXMLRPCServer.SimpleXMLRPCServer(("d6349.mysql.zone.ee", 7000))
server.register_instance(controller)
server.serve_forever()