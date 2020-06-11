from .ToolbarView import ToolbarView

class ToolbarController(object):

    def __init__(self, mainController):

        self.mainController = mainController
        #Create view with a reference to its controller to handle events
        self.view = ToolbarView(self)



    def __getattr__(self, name):
#        print "ToolbarController's getattr"
        print "ToolbarController's class: " + self.mainController.__class__.__name__
        return getattr(self.mainController, name)

#    def onNewFileClick(self, event):
#        print "ToolbarController onNewFileClick"
#        self.controller.newFile()



