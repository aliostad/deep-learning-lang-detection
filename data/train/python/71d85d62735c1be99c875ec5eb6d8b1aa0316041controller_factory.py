from vlc_controller import VLCController
from volume_controller import VolumeController
from mouse_controller import MouseController

class ControllerFactory:
    def __init__(self):
        self.vlcController = VLCController()
        self.volumeController = VolumeController()
        self.mouseController = MouseController()

    def get_volume_controller(self):
        return self.volumeController

    def get_vlc_controller(self):
        return self.vlcController
    
    def get_mouse_controller(self):
        return self.mouseController

    

