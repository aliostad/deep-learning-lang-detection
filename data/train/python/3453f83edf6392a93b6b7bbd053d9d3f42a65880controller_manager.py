# Copyright Qwilt, 2013
# 
# The code contained in this file may not be used by any other entities without explicit written permission from Qwilt.
# 
# Author: effiz

if  __package__ is None:
    G_NAME_MODULE_STORAGE_CONTROLLER = "unknown"
    G_NAME_GROUP_STORAGE_CONTROLLER_CONTROLLER_MANAGER = "unknown"
else:
    from . import G_NAME_MODULE_STORAGE_CONTROLLER
    from . import G_NAME_GROUP_STORAGE_CONTROLLER_CONTROLLER_MANAGER


from a.infra.basic.return_codes import ReturnCodes
import dell_raid_controller
import a.infra.format.json
import a.api.yang.modules.tech.common.qwilt_tech_storage_disk.qwilt_tech_storage_disk_module_gen
blinky_generated_enums=a.api.yang.modules.tech.common.qwilt_tech_storage_disk.qwilt_tech_storage_disk_module_gen


class ControllerkManager(object):

    def __init__ (self,logger):

        self._log = logger.createLogger(G_NAME_MODULE_STORAGE_CONTROLLER, G_NAME_GROUP_STORAGE_CONTROLLER_CONTROLLER_MANAGER)
        self._candidateControllerList = {}
        self._runningControllerList   = {}


    ## Configuration related functions ##

    def preCreateController (self,key):
        self._log("precreate-controller").debug3("preCreateController(key=%s)  was called, self._candidateControllerList[%s] = None",key,key)

        if key in self._candidateControllerList:
            self._log("controller-already-exist").error("a controller named '%s' already exists",key)
            return ReturnCodes.kGeneralError

        self._candidateControllerList[key] = None

        return ReturnCodes.kOk


    def createController (self,key,implementatonType):

        controller = None
        if ((implementatonType == blinky_generated_enums.ControllerImplementationType.kDellH710) or
            (implementatonType == blinky_generated_enums.ControllerImplementationType.kDellH810)):
            controller = dell_raid_controller.H710RaidController(key,self._log,0)# TODO: remove this later
        ## TODO: continue this "which" statement

        self._candidateControllerList[key] = controller
        return controller

    def managerTrxStart (self):
        self._log("controller-manager-trx-start").debug3("managerTrxStart()  was called, running --> candidate, running = %s ,candidate = %s",self._runningControllerList,self._candidateControllerList)
        self._candidateControllerList = self._runningControllerList.copy()
        return ReturnCodes.kOk


    def managerTrxVerifyPublicConfig (self):

        self._log("controller-manager-trx-verify-public").debug3("managerTrxVerifyPublicConfig() was called")
        ## place holder

        return ReturnCodes.kOk

    def managerTrxCommit (self):
        self._log("controller-manager-trx-start").debug3("managerTrxCommit()  was called, candidate --> running, running = %s ,candidate = %s",self._runningControllerList,self._candidateControllerList)
        self._runningControllerList = self._candidateControllerList.copy()
        return ReturnCodes.kOk


    def managerTrxAbort (self):
        self._log("controller-manager-trx-abort").debug3("managerTrxAbort() was called, None --> candidate")
        self._candidateControllerList = None
        return ReturnCodes.kOk


    ## Periodic-work related functions ##

    def getController (self,controllerName):
        if controllerName in self._runningControllerList:
            return self._runningControllerList[controllerName]

        self._log("cannot-fetch-running-controller").debug2("could not fetch running controller '%s'", controllerName)
        return None


    ## TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP
    def init (self,diskControllersCfgJson):
        self._log("controller-mngr-init").debug2("ControllerManager init() is called (diskControllersCfgJson=%s)",diskControllersCfgJson)

        diskControllersCfg = None 
        try:

            diskControllersCfg = a.infra.format.json.readFromFile(self._log,diskControllersCfgJson)
            self._log("disk-controller-cfg-obtained").debug3("diskControllersCfg for LogicalDiskManager init() is %s",diskControllersCfg)

        except Exception:
            self._log("bad-cfg-json").exception("error loading json file '%s'",diskControllersCfgJson)
            return ReturnCodes.kGeneralError
            

        # create disk controller objects
        for controllerCfg in diskControllersCfg:
            ctlName = controllerCfg["name"]
            ctlType = controllerCfg["type"]
            ctlInternalId = controllerCfg["internalId"]
            newController = None

            if ctlName in self._runningControllerList:
                self._log("duplicate-controller-name").error("controller-name=%s is not unique!",ctlName)
                return ReturnCodes.kBadParameter

            # factory stage - create object
            if (ctlType == "H710RaidController"):
                newController = dell_raid_controller.H710RaidController(ctlName,ctlInternalId,self._log)

                if (len(self._runningControllerList) == 0): #if this is the first controller, make sure the dell OM services are up
                    rc = newController.init()
                    if (rc != ReturnCodes.kOk):
                        self._log("dell-controller-init-fail").error("H710RaidController failed to be initialized! controllerName='%s'",ctlName)
                        return ReturnCodes.kGeneralError

                self._log("dell-controller-h710-created").debug1("H710RaidController was created (name=%s,index=%s)",ctlName,ctlInternalId)

            if (newController == None):
                self._log("unsupported-controller-type").error("controller type '$s' is not a familiar one!",ctlType)
                return ReturnCodes.kBadParameter
            else:
                # add to pool
                self._runningControllerList[ctlName] = newController
                self._log("adding-controller-to-manager-pool").debug2("controller (name=%s) was added to LogicalDiskManager pool",ctlName)

        return ReturnCodes.kOk
    ## TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP
