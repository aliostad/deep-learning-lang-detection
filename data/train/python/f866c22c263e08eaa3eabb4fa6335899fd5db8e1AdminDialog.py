
from PyQt4.QtCore import *
from PyQt4.QtGui import *

from Ui_AdminDialog import Ui_AdminDialog

class AdminDialog( QDialog, Ui_AdminDialog ):

    @classmethod
    def run( cls, parent=None, controller=None ):
        dialog = AdminDialog( parent, controller )
        dialog.exec_()

    def __init__( self, parent=None, controller=None ):
        QDialog.__init__( self, parent )
        self.setupUi( self )
        self.setController( controller )

    def setController( self, controller ):
        self.uSuppliersTab.setController( controller )
        self.uSourceTypesTab.setController( controller )
