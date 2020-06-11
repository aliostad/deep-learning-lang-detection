"""
Create a new blender object inside your scene. Then add a new module Python
controller BlenderController.main and connect it with a new always sensor.
"""

import bpy
import sys

# Put the path of Togetic library inside the syspath
sys.path.append("../")

from Togetic.Blender import PositionController

static_controller = None
def main(controller):
    global static_controller
    if static_controller is None:
        addr = bpy.context.scene.socket_address
        try:
            static_controller = PositionController(addr, controller.owner)
        except (FileNotFoundError, ConnectionRefusedError):
            static_controller = None
    if static_controller is not None:
        static_controller.run()
