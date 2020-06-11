from controller_generic import ControllerGeneric
from controller_ssd1311 import ControllerSSD1311
from connector import GPIO4Bit
from connector import GPIO74HC595
from connector import MCP23017

DISP_WIDTH = 16
DISP_HEIGHT = 2

LINE_MAIN = 0
LINE_DETAILS = 1

class HD44780Display:
    def __init__(self):
        # TODO: This should probably be in a config file or something
        #self._controller = ControllerGeneric(GPIO4Bit(18, 23, [7, 8, 25, 24]))
        #self._controller = ControllerSSD1311(GPIO74HC595(18, 23, 7, 25, 8))
        self._connector = MCP23017()
        self._controller = ControllerSSD1311(self._connector)

    def start(self):
        self._controller.start()

    def stop(self):
        self._controller.stop()

    def text(self, text, line):
        self._controller.send_line(line, text.center(DISP_WIDTH, " ")[0:DISP_WIDTH])

    def width(self, line):
        return DISP_WIDTH
