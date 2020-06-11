__author__ = 'zthorn'

from ._base import Menu
from . import colors

class TemperatureMenu(Menu):
    color = colors.RED

    def display(self, controller):
        if controller.thermometer:
            temp = 'TEMP: %s'
        else:
            temp = 'THERMOMETER OFFLINE'
        set_text = self._get_set_text(controller)
        return temp+'\n'+set_text

    def _get_set_text(self, controller):
        return 'POWER OFFLINE'

class PowerHeatMenu(TemperatureMenu):
    def _get_set_text(self, controller):
        if controller.power:
            return 'POWER: %s' %int(controller.power.value*100)+'%'
        else:
            return super()._get_set_text(controller)

    def on_up(self, controller):
        if controller.power:
            controller.power.value += 0.05
            if controller.power.value > 1.0:
                controller.power.value = 1.0

    def on_down(self, controller):
        if controller.power:
            controller.power.value -= 0.05
            if controller.power.value < 0.0:
                controller.power.value = 0.0

class SetPointHeatMenu(TemperatureMenu):
    def _get_set_text(self, controller):
        if controller.pid:
            return 'SET:  %s' % controller.pid.value
        else:
            return super()._get_set_text(controller)

    def on_up(self, controller):
        if controller.pid:
            controller.pid.value += 1
            if controller.pid.value > 110:
                controller.pid.value = 110

    def on_down(self, controller):
        if controller.pid:
            controller.pid.value -= 1
            if controller.pid.value < 0:
                controller.pid.value = 0