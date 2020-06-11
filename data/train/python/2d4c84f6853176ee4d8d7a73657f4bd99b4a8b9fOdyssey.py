#!/usr/bin/env python
# -*- coding: utf-8 -*-
from GPSController import GPSController
from PiCamController import PiCamController
from FrameBufferController import FrameBufferController
import os
import time
import sys

class Odyssey():
    def __init__(self):
        # initialize GPSController
        try:
            # it fails when gpsd is not working
            self.gpsController = GPSController()
            self.gpsController.start()

        except:
            exc_info = sys.exc_info()
            print 'Unexpected error on recording: ', exc_info[0], exc_info[1]
            self.gpsController = None

        # prep camera
        self.cameraController = PiCamController(self.gpsController)
        self.cameraController.start()

        # copy /dev/fb0 to /dev/fb1
        self.frameBufferController = FrameBufferController()
        self.frameBufferController.start()

    def datetime(self, format='%Y-%m-%dT%H:%M:%S'):
        if self.gpsController and self.gpsController.utc:
            timeObj = time.strptime(self.gpsController.utc,
                                    '%Y-%m-%dT%H:%M:%S.%fz')
            return time.strftime(format, timeObj)

        else:
            return time.strftime(format, time.gmtime())

    def switch_preview(self):
        if self.cameraController.camera.previewing:
            self.cameraController.hide_preview()
        else:
            self.cameraController.show_preview()

    def switch_record(self):
        if (
                self.gpsController
            and self.gpsController.is_logging
            and self.cameraController.recording
        ):
            self.cameraController.stop_recording()
            self.gpsController.stop_logging()

        elif self.cameraController.recording:
            self.cameraController.stop_recording()

        elif self.gpsController and self.gpsController.is_logging:
            self.gpsController.stop_logging()

        else:
            dt = self.datetime('%Y%m%d_%H%M%S')
            dirName = os.path.dirname( os.path.abspath( __file__ ) )
            self.cameraController.start_recording(dirName + '/' + dt + '.h264')
            if self.gpsController:
                self.gpsController.start_logging(dirName + '/' + dt + '.csv')

    def stop(self):
        self.frameBufferController.stopController()
        self.cameraController.stopController()
        if self.gpsController:
            self.gpsController.stopController()

if __name__ == "__main__":
    try:
        odyssey = Odyssey()
        odyssey.cameraController.show_preview()
        odyssey.cameraController.start_recording()
        time.sleep(10)

    except KeyboardInterrupt:
        print 'Cancelled'

    except:
        exc_info = sys.exc_info()
        print 'Unexpected error on recording: ', exc_info[0], exc_info[1]

    finally:
        odyssey.stop()
        print 'Done.'
