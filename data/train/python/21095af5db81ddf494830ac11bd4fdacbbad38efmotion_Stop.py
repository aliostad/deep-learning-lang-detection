"""
MotionStop

Stops any ALMotion task.
"""

from motion_CurrentConfig import *

####
# Create python broker

try:
  broker = ALBroker("pythonBroker","127.0.0.1",9999,IP, PORT)
except RuntimeError,e:
  print("cannot connect")
  exit(1)

####
# Create motion proxy

print "Creating motion proxy"


try:
  motionProxy = ALProxy("ALMotion")
except Exception,e:
  print "Error when creating motion proxy:"
  print str(e)
  exit(1)


motionProxy.setSupportMode(motion.SUPPORT_MODE_DOUBLE_LEFT)
motionProxy.killAll()
motionProxy.setBodyStiffness(0.0,1)


