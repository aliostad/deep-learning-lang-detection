from qt import QString
from kdecore import KShortcut
from kdeui import KGuiItem, KAction

from useless.kdebase.actions import BaseItem
from paella.kde.base.actions import BaseAction
        
class ManageMachinesItem(BaseItem):
    def __init__(self):
        BaseItem.__init__(self, 'manage machines', 'system',
                          'manage machines', 'manage machines')

class ManageMachinesAction(BaseAction):
    def __init__(self, slot, parent):
        BaseAction.__init__(self, ManageMachinesItem(), 'ManageMachines', slot, parent)

class ManageDiskConfigItem(BaseItem):
    def __init__(self):
        comment = 'manage diskconfig'
        BaseItem.__init__(self, comment, 'blockdevice', comment, comment)

class ManageDiskConfigAction(BaseAction):
    def __init__(self, slot, parent):
        BaseAction.__init__(self, ManageDiskConfigItem(), 'ManageDiskConfig',
                            slot, parent)
        
class ManageKernelsItem(BaseItem):
    def __init__(self):
        comment = 'manage kernels'
        BaseItem.__init__(self, comment, 'memory', comment, comment)

class ManageKernelsAction(BaseAction):
    def __init__(self, slot, parent):
        BaseAction.__init__(self, ManageKernelsItem(), 'ManageKernels',
                            slot, parent)

        
ManageActions = {
    'machine' : ManageMachinesAction,
    'diskconfig' : ManageDiskConfigAction,
    'kernels' : ManageKernelsAction
    }

ManageActionsOrder = ['machine',
                      'diskconfig',
                      'kernels']
