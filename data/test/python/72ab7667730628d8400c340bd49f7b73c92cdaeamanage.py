# -*- coding: utf-8 -*-
'''
Created on 30.08.2010
@author: Lubos Melichar
'''

import manage_gui
import manage_comm
import threading, time, sys
from PyQt4 import QtCore, QtGui

if __name__ == "__main__":
        
    #COMM THREAD
    myCommSH = manage_comm.CommSharedMemory()
    myManageComm = manage_comm.ManageComm(SmComm = myCommSH)                                
    myManageComm.start()
    print "Communication thread is running.."


    #GUI THREAD
    app = QtGui.QApplication(sys.argv)
    myapp = manage_gui.wrapper_gui_ewitis(SmComm = myCommSH)
    myapp.show()
    sys.exit(app.exec_())
    
    #myManageGui.start()
    
    
    #myManageComm.start()
    #myManageGui.start()
    
     

