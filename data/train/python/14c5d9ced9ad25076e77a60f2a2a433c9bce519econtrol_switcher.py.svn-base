#!/usr/bin/env python
import roslib
roslib.load_manifest('ee_cart_imped_control')
import rospy
import pr2_controller_manager.pr2_controller_manager_interface

class PR2CMClient:
    '''
    This class switches between the ee_cart_imped controller and the 
    standard arm_navigation suite of controllers on the PR2 arms.

    When invoked, the methods stop one controller and start the other.  
    They require that the controllers are already loaded (albeit stopped).
    The arm_navigation controllers can be loaded from that stack or by
    launching the 
    pr2_tabletop_manipulation_launch/launch/pr2_tabletop_manipulation.launch 
    file.  The ee_cart_imped controller can be launched using the
    ee_cart_imped_launch/launch/load_ee_cart_imped.launch file.  Note that
    using the ee_cart_imped.launch file will not work as that not only starts
    the ee_cart_imped controller, but also continuously inhibits the
    arm_navigation controllers.
    '''
   
    @staticmethod
    def load_ee_cart_imped(arm_name):
        '''
        Stops the standard arm controllers and starts the ee_cart_imped
        controller.
        @type arm_name: string
        @param arm_name: the arm to control.  Must be 'right_arm' or 'left_arm'
        '''
        rospy.logdebug('Starting ee_cart_imped controller on '+ arm_name)
        status = pr2_controller_manager.pr2_controller_manager_interface.stop_controller(arm_name[0]+'_arm_controller')
        status = pr2_controller_manager.pr2_controller_manager_interface.stop_controller\
            (arm_name[0]+'_arm_cartesian_trajectory_controller')
        status = pr2_controller_manager.pr2_controller_manager_interface.stop_controller\
            (arm_name[0]+'_arm_cartesian_pose_controller')
        status = pr2_controller_manager.pr2_controller_manager_interface.start_controller\
            (arm_name[0]+'_arm_cart_imped_controller')
        rospy.logdebug('Controller started')
        return status
        
    @staticmethod
    def load_cartesian(arm_name):
        '''
        Stops the ee_cart_imped controller and the arm_navigation controllers
        and loads the standard r_arm_controller.
        @type arm_name: string
        @param arm_name: the arm to control.  Must be 'right_arm' or 'left_arm'
        '''
        rospy.logdebug('starting cartesian controller on '+ arm_name)
        status = pr2_controller_manager.pr2_controller_manager_interface.stop_controller\
            (arm_name[0]+'_arm_cart_imped_controller')
        status = pr2_controller_manager.pr2_controller_manager_interface.start_controller(arm_name[0]+'_arm_controller')
        status = pr2_controller_manager.pr2_controller_manager_interface.stop_controller\
            (arm_name[0]+'_arm_cartesian_trajectory_controller')
        status = pr2_controller_manager.pr2_controller_manager_interface.stop_controller\
            (arm_name[0]+'_arm_cartesian_pose_controller')
        rospy.logdebug('Controller started')
        return status
