#! /usr/bin/python

import sys
from PyQt4 import QtCore, QtGui, uic

from controller_gui import Ui_Frame as QTControllerGUIFrame

from subprocess import Popen

class ControllerGUIFrame(QtGui.QFrame):
    def __init__(self):
        super(ControllerGUIFrame, self).__init__()
        self.init_ui()

    def init_ui(self):
        self.ui = QTControllerGUIFrame()
        self.ui.setupUi(self)

        self.ui.start_button.clicked.connect(self.start_button_clk)
        self.ui.kill_button.clicked.connect(self.kill_button_clk)
        self.controller = "l_arm_controller"
        self.ui.controller_combo.addItem("l_arm_controller")
        self.ui.controller_combo.addItem("l_cart")
        self.ui.controller_combo.addItem("r_arm_controller")
        self.ui.controller_combo.addItem("r_cart")
        self.ui.controller_combo.activated[str].connect(self.combo_activated)

    def combo_activated(self, text):
        self.controller = text

    def start_button_clk(self):
        if self.controller is not None:
            Popen("rosrun pr2_controller_manager pr2_controller_manager start %s" % self.controller, 
                  shell=True)

    def kill_button_clk(self):
        if self.controller is not None:
            Popen("rosrun pr2_controller_manager pr2_controller_manager stop %s" % self.controller, 
                  shell=True)

def main():
    app = QtGui.QApplication(sys.argv)
    frame = ControllerGUIFrame()
    frame.show()
    sys.exit(app.exec_())

if __name__ == "__main__":
    main()
