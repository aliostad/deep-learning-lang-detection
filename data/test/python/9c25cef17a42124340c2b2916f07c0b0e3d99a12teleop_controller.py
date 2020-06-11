

import os

class TeleopController:

    def __init__(self, sp, hid_sp, control_stick=None, drive_controller=None, record_controller=None, playback_controller=None):
        self.sp = sp
        self.hid_sp = hid_sp

        if control_stick and drive_controller and record_controller and playback_controller:
            self.control_stick = control_stick
            self.drive_controller = drive_controller
            self.record_controller = self.record_controller
            self.playback_controller = self.playback_controller
            self.playback = False
            self.control_stick.add_listener(self._joylistener)


    def poll(self):
        self.sp.poll()
        self.hid_sp.poll()

    def _joylistener(self, sensor, state_id, datum):
        if state_id == "button2":
            if datum:
                os.execv(sys.executable, [sys.executable, 'robot.py', 'sim'])

        if state_id == "button9":
            if datum:
                self.drive_macro.engage()
        if state_id == "button8":
            if datum:
                self.record_controller.disengage()
                del self.playback_controller
                self.playback_controller = PlaybackController(self.record_controller.instructions, self.talon_arr, revert_controller = self.drive_controller)
                print(self.record_controller.instructions)


        if state_id == "button7":
            if datum and not self.playback: #prevents extra presses from causing issues
                    self.drive_controller.disengage()
                    self.playback_controller.engage()
                    self.playback = True
        if state_id == "button6":
            if datum and self.playback: #same as above
                self.playback_controller.disengage()
                self.drive_controller.engage()
                self.playback = False

