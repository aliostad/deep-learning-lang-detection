#!/usr/bin/python

import signal
import sys
from PyQt4 import QtGui, QtCore
from ValveController.MainWnd import *


valve_controller = None

def sigterm_handler(signum, frame):
	global valve_controller

	# stop and close valve controller
	valve_controller.close()
	os._exit(0)

def main():
	global valve_controller

	signal.signal(signal.SIGTERM, sigterm_handler)
	signal.signal(signal.SIGINT, sigterm_handler)

	app = QtGui.QApplication(sys.argv)
	valve_controller = MainWnd()
	sys.exit(app.exec_())


if __name__ == '__main__':
	main()

	while 1:
		sleep(1)
