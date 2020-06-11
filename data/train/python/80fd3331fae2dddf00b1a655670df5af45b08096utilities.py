#!/usr/bin/env python
import roslib; roslib.load_manifest('faa_utilities')
import rospy

from faa_utilities.srv import SaveParams, SaveParamsResponse
from faa_utilities import FileTools


file_tools = FileTools()

def handle_save_config_params(req):
    file_tools.save_config_params(req.params)
    return SaveParamsResponse("success")

def utilities_server():
    rospy.init_node('utilities_server')
    s = rospy.Service('save_config_params', SaveParams, handle_save_config_params)
    rospy.spin()

if __name__ == "__main__":
    utilities_server()
