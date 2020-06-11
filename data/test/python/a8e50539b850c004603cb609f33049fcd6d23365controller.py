from smaclib.twisted.plugins import module
from smaclib.conf import settings

class ControllerMaker(module.ModuleMaker):
    tapname = "smac-controller"
    description = "Controller module for SMAC."

    def loadSettings(self, configfile):
        from smaclib.modules.controller import settings as controller_settings
        settings.load(controller_settings)
        
        super(ControllerMaker, self).loadSettings(configfile)
        
    def getModule(self):
        from smaclib.modules.controller import module
        return module.Controller()


serviceMaker = ControllerMaker()