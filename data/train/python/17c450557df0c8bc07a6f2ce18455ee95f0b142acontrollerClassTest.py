import controllerClass
import time
import sys

def control_call_back(xboxControlId, value):
    print ("Control ID = " + str(xboxControlId) +  " Value = " + str(value))

def left_thumb_x(xValue):
    print("LX" + str(xValue))

def right_thumb_x(xValue):
    print("RX" + str(xValue))

def right_thumb_y(yValue):
    print("RY" + str(yValue))

def left_thumb_y(yValue):
    print("LY" + str(yValue))

def left_trigger(value):
    print("Left Trigger:" + str(value))

def right_trigger(value):
    print("Right Trigger: " + str(value))

if __name__ == '__main__':
    controller = controllerClass.Controller(controller_call_back=None, dead_zone=0.1, scale=1, invert_Y_axis=True, controller_is_xbox=True)
    xboxControls = controllerClass.XboxControls
    controller.setup_control_call_back(controller.controller_mapping.L_THUMB_X, left_thumb_x)
    controller.setup_control_call_back(controller.controller_mapping.L_THUMB_Y, left_thumb_y)
    controller.setup_control_call_back(controller.controller_mapping.L_TRIGGER, left_trigger)
    controller.setup_control_call_back(controller.controller_mapping.R_TRIGGER, right_trigger)
    controller.setup_control_call_back(controller.controller_mapping.R_THUMB_X, right_thumb_x)
    controller.setup_control_call_back(controller.controller_mapping.R_THUMB_Y, right_thumb_y)

    try:
        controller.start()
        print("Controller startup")
        while True:
            time.sleep(1)

    except KeyboardInterrupt:
        print ("Exiting")

    except:
        print("Unknown Error" + sys.exc_info()[0])
        raise

    finally:
        controller.stop()

