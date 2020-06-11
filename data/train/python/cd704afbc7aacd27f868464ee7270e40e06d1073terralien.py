import config

import pygsty
from pygsty.camera import Camera
from pygsty.drawing import *

import controllers
import data
import models

def main():
    pygsty.start(1024, 768, False)

    models.build_world()

    pygsty.engine().push_controller(pygsty.controllers.CameraController((100, 100), 100))
    pygsty.engine().push_controller(pygsty.controllers.PerformanceController())
    pygsty.engine().push_controller(controllers.GameController())
    pygsty.engine().push_controller(controllers.SideMenuController())
    pygsty.engine().push_controller(controllers.EventLogController())

    pygsty.logger.info("Game Initialized")
    pygsty.run()

if __name__ == '__main__':
    main()
