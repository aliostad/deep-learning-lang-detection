# Copyright Qwilt, 2012
# 
# The code contained in this file may not be used by any other entities without explicit written permission from Qwilt.
# 
# Author: effiz

if  __package__ is None:
    G_NAME_MODULE_STORAGE_CONTROLLER = "unknown"
else:
    from . import G_NAME_MODULE_STORAGE_CONTROLLER

from a.infra.basic.return_codes import ReturnCodes



class Controller(object):
    """
    A base class representing a disk controller.
    """
    def __init__ (self,name,internalId,groupName,logger):
        self._log = logger.createLogger(G_NAME_MODULE_STORAGE_CONTROLLER, groupName)
        self._index = internalId # TODO : take this from config
        self._controllerName = name
        self._runningControllerConfig   = None
        self._candidateControllerConfig = None
        self._activeControllerConfig    = None 


    ## Configuration related functions ##
    
    def controllerTrxStart (self):
        self._log("controller-trx-start").debug3("diskControllerTrxStart()  was called for controller %s, running --> candidate",self._controllerName)
        self._candidateControllerConfig.copyFrom(self._runningControllerConfig)
        return ReturnCodes.kOk

    def controllerValueSet (self,data):
        self._log("controller-value-set").debug3("controllerValueSet(data=%s)  was called for controller %s, data --> candidate",data,self._controllerName)
        self._candidateControllerConfig.copyFrom(data)
        return ReturnCodes.kOk

    def controllerTrxCommit (self):
        self._log("controller-trx-commit").debug3("controllerTrxCommit()  was called for controller %s, candidate --> running",self._controllerName)
        self._runningControllerConfig.copyFrom(self._candidateControllerConfig)
        return ReturnCodes.kOk

    def controllerTrxAbort (self):
        self._log("controller-trx-abort").debug3("controllerTrxAbort()  was called for controller %s, None --> candidate",self._controllerName)
        self._candidateControllerConfig  = None
        return ReturnCodes.kOk



