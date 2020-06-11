from core import simple_joy
from framework import controller


class ManualControl(controller.ControllerProcess):
    def __init__(self, bot, logger_function, quit_super):
        controller.ControllerProcess.__init__(self, bot, logger_function)
        self.controls = simple_joy.Runner(bot, self.log, quit_super)
        self.quit_super = quit_super

    def _mode(self):
        self.controls._mode()

    def _quit(self):
        print ('manual control quitting')
        self.controls.quit()
        controller.ControllerProcess.quit(self)
        self.quit_super()
