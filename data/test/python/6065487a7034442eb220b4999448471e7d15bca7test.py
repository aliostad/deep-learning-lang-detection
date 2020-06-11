from subprocess import check_output
import sys
import os
sys.path.insert(0, "/LeapSDK/lib")
import LeapPython
import Leap


controller = Leap.Controller();
controller.set_policy(Leap.Controller.POLICY_BACKGROUND_FRAMES)
controller.set_policy(Leap.Controller.POLICY_IMAGES)
controller.set_policy(Leap.Controller.POLICY_OPTIMIZE_HMD)
controller.enable_gesture(Leap.Gesture.TYPE_SCREEN_TAP)
controller.enable_gesture(Leap.Gesture.TYPE_KEY_TAP)

while True:
	frame = controller.frame()

	for gesture in frame.gestures():
		if gesture.type == Leap.Gesture.TYPE_SCREEN_TAP:
			print "hello"
			print os.system('git add -A; git commit -am "Automated commit by Leap Motion";')
		elif gesture.type == Leap.Gesture.TYPE_KEY_TAP:
			print "bye"
			print os.system("git push")

