#! /usr/bin/env python
import os, roslib, time
roslib.load_manifest('openrave_actionlib')
roslib.load_manifest('pr2_controller_manager')

import rospy, sys
import rosparam
import yaml
from pr2_controller_manager import pr2_controller_manager_interface
from pr2_mechanism_msgs.msg import MechanismStatistics
from pr2_mechanism_msgs.srv import *

pr2_controller_manager_interface.stop_controller('l_arm_controller')
pr2_controller_manager_interface.stop_controller('r_arm_controller')
pr2_controller_manager_interface.stop_controller('torso_controller')

name_yaml = yaml.load(open(os.path.join(roslib.packages.get_pkg_dir('openrave_actionlib'),'pr2_midbody_controller.yaml')))
rosparam._set_param("",name_yaml)
time.sleep(0.5) # wait for parameter server

rospy.wait_for_service('pr2_controller_manager/load_controller')
rospy.ServiceProxy('pr2_controller_manager/load_controller', LoadController)('midbody_controller')
pr2_controller_manager_interface.start_controller('midbody_controller')
