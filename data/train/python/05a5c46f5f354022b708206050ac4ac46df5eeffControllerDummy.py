#!/usr/bin/env python
""" Ockle PDU and servers manager
A dummy controller, useful for testing

Created on Oct 05, 2012

@author: Guy Sheffer <guy.sheffer at mail.huji.ac.il>
"""
from controllers.ControllerTemplate import ControllerTemplate
   
class Dummy(ControllerTemplate):
    def __init__(self,name,controllerConfigDict={},controllerParams={}):
        ControllerTemplate.__init__(self,name,controllerConfigDict={},controllerParams={})
        self.setState(True)
        return
    
    def updateData(self):
        pass
    
    def _setControlState(self,state):
        self.state=True
        return True
    
    def _getControlState(self):
        try:
            return self.state
        except:
            self.state = True #init
            return False