import sys
sys.path.append("../common")

from threading import Thread
from AudioController import AudioController
from LeapController import LeapController

from Config import Config

class Controller(Thread):
    def __init__(self, filePath):
        Thread.__init__(self)
        self.leap = LeapController()
        self.leftSampler = AudioController(filePath, self.leap.getScale, self.leap.getMasterVolume)
        self.leap.start()

if __name__ == "__main__":
    scratch=Config.__getScratchFilePath__()

    Controller("../../input/"+scratch)
