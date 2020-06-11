#    This file is part of lockd, the daemon of the luftschleuse2 project.
#
#    See https://github.com/muccc/luftschleuse2 for more information.
#
#    Copyright (C) 2013 Tobias Schneider <schneider@muc.ccc.de> 
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
import logging
import time

class UserInterfaceLogic():
    def __init__(self, led_controller):
        self.led_controller = led_controller
        self.t0 = time.time()
        self.state_cache = None

    def tick(self):
        if time.time() - self.t0 > 5:
            if self.state_cache:
                self.update_state(self.state_cache)
            self.t0 = time.time()

    def update_state(self, state):
        self.state_cache = state
        tainted = state.is_state_tainted()

        if state.state == state.State.DOWN:
            if not tainted:
                self.led_controller.set_led('down', self.led_controller.LedState.ON)
            else:
                self.led_controller.set_led('down', self.led_controller.LedState.BLINK_SLOW)
            self.led_controller.set_led('closed', self.led_controller.LedState.OFF)
            self.led_controller.set_led('member', self.led_controller.LedState.OFF)
        if state.state == state.State.CLOSED:
            if not tainted:
                self.led_controller.set_led('closed', self.led_controller.LedState.ON)
            else:
                self.led_controller.set_led('closed', self.led_controller.LedState.BLINK_SLOW)
            self.led_controller.set_led('down', self.led_controller.LedState.OFF)
            self.led_controller.set_led('member', self.led_controller.LedState.OFF)

        if state.state == state.State.MEMBER:
            if not tainted:
                self.led_controller.set_led('member', self.led_controller.LedState.ON)
            else:
                self.led_controller.set_led('member', self.led_controller.LedState.BLINK_SLOW)
            self.led_controller.set_led('down', self.led_controller.LedState.OFF)
            self.led_controller.set_led('closed', self.led_controller.LedState.OFF)

        if state.state == state.State.PUBLIC:
            if not tainted:
                self.led_controller.set_led('closed', self.led_controller.LedState.ON)
                self.led_controller.set_led('down', self.led_controller.LedState.ON)
                self.led_controller.set_led('member', self.led_controller.LedState.ON)
            else:
                self.led_controller.set_led('closed', self.led_controller.LedState.BLINK_SLOW)
                self.led_controller.set_led('down', self.led_controller.LedState.BLINK_SLOW)
                self.led_controller.set_led('member', self.led_controller.LedState.BLINK_SLOW)

