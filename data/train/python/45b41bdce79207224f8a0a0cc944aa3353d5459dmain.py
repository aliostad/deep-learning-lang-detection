import sys
from PyQt5 import QtWidgets

from lib.model import model
from lib.view import window, printer
from lib.controller import controller
import config

def main():
    """
    Function called on program initialization
    """
    # generate the Config object
    config_obj = config.Config()

    # initialize the Controller object
    current_controller = controller.Controller(config_obj)

    # initialize the Model object
    current_model = model.Model(current_controller)
    current_controller.model = current_model

    # initialize a Window
    app = QtWidgets.QApplication(sys.argv)
    win = window.MainWindow(current_controller)
    current_controller.window = win
    sys.exit(app.exec_())

main()
