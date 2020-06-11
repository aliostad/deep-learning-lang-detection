import Mac.Driver.OsXSystemDriver
import Mac.Controller.VLCController
import Mac.Controller.FinderController


class MacApplicationsManager:

    def __init__(self):
        pass

    def handle(self, strCode):
        osXSystemDriver = Mac.Driver.OsXSystemDriver.OsXSystemDriver()
        activeApp = osXSystemDriver.getActiveAPP()

        if activeApp == Mac.Controller.VLCController.VLCController.appName:
            return Mac.Controller.VLCController.VLCController().handle(strCode)
        else:
            #default - finder
            return Mac.Controller.FinderController.FinderController().handle(strCode)