'''
LeapMotion driver for acquiring hand information and gestures
September 10, 2015
@author: Jami L Johnson
'''
import Leap, sys, thread, time

class LeapListener(Leap.Listener):
    def on_init(self,controller):
        print 'LeapMotion initialized'

    def on_connect(self,controller):
        print 'LeapMotion connected'
        controller.enable_gesture(Leap.Gesture.TYPE_SWIPE);
        controller.config.set("Gesture.Swipe.MinLength", 100.0)
        controller.config.set("Gesture.Swipe.MinVelocity", 600)
        controller.config.save()
        
    def on_disconnect(self,controller):
        print 'LeapMotion disconnected'

    def on_exit(self,controller):
        print 'Exited LeapMotion.'

    def get_frame(self,controller):
        frame = controller.frame()
        return frame.hands, frame.gestures()
