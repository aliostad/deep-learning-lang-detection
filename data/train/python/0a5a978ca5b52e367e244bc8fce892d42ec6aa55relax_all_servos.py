#!/usr/bin/env python

"""
    Relax all servos by disabling the torque for each.
"""
import roslib
roslib.load_manifest('pr2lite_moveit_config')
import rospy, time
from dynamixel_controllers.srv import TorqueEnable, SetSpeed

#class dyno_torque():
#    def __init__(self):
#        # rospy.init_node('set_torque_all_servos')
#        # dynamixels = rospy.get_param('dynamixels', '')
#        dynamixels = ["head_pan_controller", "head_tilt_controller", "left_elbow_flex_controller", "left_elbow_pan_controller", "left_gripper_left_controller", "left_gripper_right_controller", "left_shoulder_pan_controller", "left_wrist_flex_controller", "left_wrist_roll_controller", "lidar_tilt_controller", "right_elbow_flex_controller", "right_elbow_pan_controller", "velo_gripper_ax12_controller", "right_shoulder_pan_controller", "right_wrist_flex_controller ", "right_wrist_roll_controller"]
#
#        self.torque_services = list()
#        self.punch_services = list()
#            
#        print dynamixels
#        for name in sorted(dynamixels):
#            # controller = name.replace("_joint", "") + "_controller"
#            controller = name
#            torque_service = '/' + controller + '/set_torque_limit'
#            print controller
#            rospy.wait_for_service(torque_service)
#            self.torque_services.append(rospy.ServiceProxy(torque_service, SetTorque))
# 
#            punch_service = '/' + controller + '/set_compliance_punch'
#            rospy.wait_for_service(punch_service)
#            self.punch_services.append(rospy.ServiceProxy(punch_service, SetPunch))
#    def set_torque(self, val):
#
#        # Relax all servos to give them a rest.
#        for set_torque in self.torque_services:
#            set_torque(val)
#
#        # Set the default speed to something small
#        for set_punch in self.punch_services:
#            set_punch(val)
#        
#if __name__=='__main__':
#    dyno_torque()
##    dyno_control()



class Relax():
    def __init__(self):
        rospy.init_node('relax_all_servos')
        
        # dynamixels = rospy.get_param('dynamixels', '')
        dynamixels = ["head_pan_controller", "head_tilt_controller", "left_elbow_flex_controller", "left_elbow_pan_controller", "left_gripper_left_controller", "left_gripper_right_controller", "left_shoulder_pan_controller", "left_wrist_flex_controller", "left_wrist_roll_controller", "lidar_tilt_controller", "right_elbow_flex_controller", "right_elbow_pan_controller", "velo_gripper_ax12_controller", "right_shoulder_pan_controller", "right_wrist_flex_controller ", "right_wrist_roll_controller"]
        
        torque_services = list()
        speed_services = list()
            
        for name in sorted(dynamixels):
            controller = name.replace("_joint", "") + "_controller"
            
            torque_service = '/' + controller + '/torque_enable'
            rospy.wait_for_service(torque_service)  
            torque_services.append(rospy.ServiceProxy(torque_service, TorqueEnable))
            
            speed_service = '/' + controller + '/set_speed'
            rospy.wait_for_service(speed_service)  
            speed_services.append(rospy.ServiceProxy(speed_service, SetSpeed))
        
        # Set the default speed to something small
        for set_speed in speed_services:
            set_speed(0.1)

        # Relax all servos to give them a rest.
        for torque_enable in torque_services:
            torque_enable(False)
        
if __name__=='__main__':
    Relax()
