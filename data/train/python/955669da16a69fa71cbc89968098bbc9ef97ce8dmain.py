from __future__ import print_function, division

import time

import MotionController

controller = MotionController.PyMotionController()

initialized = False

# Try to initialize the motion manager
try:
    initialized = controller.initMotionManager()
except:
    print('\nException occured')

if initialized:
    print("Initialized")
    
    # Walking demo        
    controller.initWalking()
    time.sleep(1)
    controller.walk(5, 0, 0)
    time.sleep(1)
    controller.walk(5, 10)
    time.sleep(1)
    controller.walk(5, -10)
    time.sleep(1)
    controller.walk(-1, 0, 2)
    
    time.sleep(5)
    controller.stopWalking()
    time.sleep(2)
    
    # ActionEditor demo
    controller.initActionEditor()
    time.sleep(0.5)
    controller.executePage(15)

    # Wait for the motion to finish before exiting
    while controller.actionRunning():
        time.sleep(0.5)
        
    controller.executePage(1)

    # Wait for the motion to finish before exiting
    while controller.actionRunning():
        time.sleep(0.5)
        
    controller.executePage(15)

    # Wait for the motion to finish before exiting
    while controller.actionRunning():
        time.sleep(0.5)
        
    # Head demo
    controller.initHead()
    controller.moveHeadToHome()
    time.sleep(1)
    (l,r,u,d) = controller.getHeadAngleLimits()
    (p,t) = controller.getHeadPanTiltAngles()
    print('\nLimits:\n l = %d\n r = %d\n u = %d\n d = %d' % (l,r,u,d))
    print('\nPan = %d\nTilt = %d' % (p,t))
    controller.moveHead(30, 10, mode='direct')
    time.sleep(1)
    (p,t) = controller.getHeadPanTiltAngles()
    print('\nPan = %d\nTilt = %d' % (p,t))
    
    
    # Walk, then move head
    controller.initWalking()
    time.sleep(1)
    controller.moveHead(20, -10, mode='direct')
    controller.walk(5, 0, 0)
    time.sleep(1)
    
    controller.initActionEditor()
    time.sleep(0.5)
    controller.executePage(15)

    # Wait for the motion to finish before exiting
    while controller.actionRunning():
        time.sleep(0.5)
    
else:
    print('Initialization Failed')

    
   
