#!/usr/bin/env python

import roslib; roslib.load_manifest('barrett_hw')
import rospy

import barrett_control_msgs.msg as barrett_control_msgs
import barrett_control_msgs.srv as barrett_control_srvs

import controller_manager_msgs.msg as controller_manager_msgs
import controller_manager_msgs.srv as controller_manager_srvs

def get_service_proxy_when_available(name, srv_type):
    rospy.loginfo("Connecting to %s..." % name)
    rospy.wait_for_service(name)
    return rospy.ServiceProxy(name,srv_type)

class ControllerManager(object):
    def __init__(self,ns=''):
        self.load_controller = get_service_proxy_when_available('/controller_manager/load_controller', controller_manager_srvs.LoadController)
        self.unload_controller = get_service_proxy_when_available('/controller_manager/unload_controller', controller_manager_srvs.UnloadController)
        self.list_controller_types = get_service_proxy_when_available('/controller_manager/list_controller_types', controller_manager_srvs.ListControllerTypes)
        self.list_controllers = get_service_proxy_when_available('/controller_manager/list_controllers', controller_manager_srvs.ListControllers)
        self.reload_controller_libraries = get_service_proxy_when_available('/controller_manager/reload_controller_libraries', controller_manager_srvs.ReloadControllerLibraries)
        self.switch_controller = get_service_proxy_when_available('/controller_manager/switch_controller', controller_manager_srvs.SwitchController)

class WamCalibrator(object):
    def __init__(self, controller_name):
        self.controller_manager = ControllerManager()

        controller_state = None

        # Load and start calibration controller
        loaded_controllers = self.controller_manager.list_controllers()
        for c in loaded_controllers.controller:
            if c.name == controller_name:
                controller_state = c

        if not controller_state:
            response = self.controller_manager.load_controller(controller_name)

            if not response.ok:
                rospy.logerr('Could not load calibration controller: '+controller_name)
                rospy.signal_shutdown()
                return

        loaded_controllers = self.controller_manager.list_controllers()
        for c in loaded_controllers.controller:
            if c.name == controller_name:
                controller_state = c

        # Start the controllrt
        if controller_state.state != 'running':
            response = self.controller_manager.switch_controller(
                    start_controllers = [controller_name],
                    stop_controllers = [],
                    strictness = 1)

            if not response.ok:
                rospy.logerr('Could not start calibration controller: '+controller_name)
                rospy.signal_shutdown()
                return
        
        # Connect to calibration interface
        self.calibrate_joints = get_service_proxy_when_available(
                'calibration_controller/calibrate',
                barrett_control_srvs.Calibrate)

        calibration_state_sub = rospy.Subscriber(
                'calibration_controller/joint_calibration_state',
                barrett_control_msgs.SemiAbsoluteCalibrationState,
                self.calibration_state_cb)

        self.calibration_state = barrett_control_msgs.SemiAbsoluteCalibrationState()

    def calibrate(self, calibration_order):
        # Check calibration parameter
        # Get the loaded controllers

        for joint_names in calibration_order:
            try:
                rospy.loginfo("Calibrating joints: " + str(joint_names))
                self.calibrate_joints(joint_names)
            except rospy.ServiceException as e:
                pass

            all_calibrated = False
            while not all_calibrated and not rospy.is_shutdown():
                relevant_calibration_states = zip(self.calibration_state.name, self.calibration_state.calibration_state)
                
                all_calibrated = len(self.calibration_state.calibration_state) > 0 and all([s == self.calibration_state.CALIBRATED for n,s in relevant_calibration_states if n in joint_names])
                rospy.sleep(0.1)

        # Set calibrated rosparam


        # Load gravity compensation controller

        # Switch  calibration controller with gravity compensation controller

        # Unload calibration controller
        #self.controller_manager.unload_controller(controller_name)

    def calibration_state_cb(self, msg):
        self.calibration_state = msg

def main():
    rospy.init_node('wam_calibration')

    calibrator = WamCalibrator('wam/calibration_controller')

    calibration_order = [
            ['wam/UpperWristPitchJoint','wam/UpperWristYawJoint','wam/LowerWristYawJoint','wam/ShoulderYawJoint'],
            ['wam/ElbowJoint'],
            ['wam/ShoulderPitchJoint'],
            ['wam/YawJoint']]

    #calibration_order = [['wam/LowerWristYawJoint']]
    #calibration_order = [['wam/UpperWristPitchJoint','wam/UpperWristYawJoint','wam/LowerWristYawJoint','wam/ShoulderYawJoint']]
    calibrator.calibrate(calibration_order)
    
if __name__ == '__main__':
    main()
