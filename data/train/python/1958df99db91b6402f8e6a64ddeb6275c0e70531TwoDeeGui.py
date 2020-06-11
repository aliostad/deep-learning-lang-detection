__author__ = 'Lab Hatter'

from direct.showbase.DirectObject import DirectObject
from bareBonesDirectGui.LoadSaveButton import LoadSaveButton



class TwoDeeGui(DirectObject):
    def __init__(self):
        DirectObject.__init__(self)
        self.loadSaveButt = LoadSaveButton()

        # ################################################
        # EXAMPLE (below) how to setup button's positions without trial and error and print calls
        # this was used to place a LoadSaveButton before it was moved to a separate class
        # ################################################

        # self.saveButt.accept('f', self.saveButt.editStart, extraArgs=[base.mouseWatcherNode])
        # self.saveButt.accept('f-up', self.editSaveButtStop)
    #
    # def editLoadButtStop(self):
    #     print self.loadButt.getPos(aspect2d)
    #     self.loadButt.editStop(render2d)
    #
    # def editSaveButtStop(self):
    #     print self.saveButt.getPos(aspect2d)
    #     self.saveButt.editStop(render2d)