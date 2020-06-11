import roslib; roslib.load_manifest('hrl_pr2_arms')
import rospy
import rosparam
import roslib.substitution_args

from pr2_mechanism_msgs.srv import LoadController, UnloadController, SwitchController, ListControllers

POSSIBLE_ARM_CONTROLLERS = ['%s_arm_controller', '%s_cart']

##
# Offers controller switching inside python on the fly.
class ControllerSwitcher:
    def __init__(self):
        self.load_controller = rospy.ServiceProxy('pr2_controller_manager/load_controller', 
                                                  LoadController)
        self.unload_controller = rospy.ServiceProxy('pr2_controller_manager/unload_controller', 
                                                    UnloadController)
        self.switch_controller_srv = rospy.ServiceProxy('pr2_controller_manager/switch_controller', 
                                                        SwitchController)
        self.list_controllers_srv = rospy.ServiceProxy('pr2_controller_manager/list_controllers', 
                                                       ListControllers)
        self.load_controller.wait_for_service()
        self.unload_controller.wait_for_service()
        self.switch_controller_srv.wait_for_service()
        self.list_controllers_srv.wait_for_service()
        rospy.loginfo("[pr2_controller_switcher] ControllerSwitcher ready.")

    ##
    # Switches controller.
    # @param old_controller Name of controller to terminate.
    # @param new_controller Name of controller to activate.  Can be same as old_controller
    #                       if the object is to only change parameters.
    # @param param_file YAML file containing parameters for the new controller.
    # @return Success of switch.
    def switch(self, old_controller, new_controller, param_file=None):
        if param_file is None:
            self.load_controller(new_controller)
            resp = self.switch_controller_srv([new_controller], [old_controller], 1)
            self.unload_controller(old_controller)
            return resp.ok
        else:
            params = rosparam.load_file(roslib.substitution_args.resolve_args(param_file))
            rosparam.upload_params("", params[0][0])
            self.switch_controller_srv([], [old_controller], 1)
            self.unload_controller(old_controller)
            if old_controller != new_controller:
                self.unload_controller(new_controller)
            self.load_controller(old_controller)
            if old_controller != new_controller:
                self.load_controller(new_controller)
            resp = self.switch_controller_srv([new_controller], [], 1)
            return resp.ok

    ##
    # Switches controller without having to specify the arm controller to take down.
    # @param arm (r/l)
    # @param new_controller Name of new controller to load
    # @param param_file YAML file containing parameters for the new controller.
    # @param possible_controllers List of possible controller names like "%s_cart" to lookup and take down
    # @return Success of switch.
    def carefree_switch(self, arm, new_controller, param_file=None, possible_controllers=None):
        if '%s' in new_controller:
            new_controller = new_controller % arm
        if param_file is not None:
            params = rosparam.load_file(roslib.substitution_args.resolve_args(param_file))
            rosparam.upload_params("", params[0][0])
        if possible_controllers is None:
            possible_controllers = POSSIBLE_ARM_CONTROLLERS
        check_arm_controllers = [controller % arm for controller in possible_controllers]
        resp = self.list_controllers_srv()
        start_controllers, stop_controllers = [new_controller], []
        for i, controller in enumerate(resp.controllers):
            if controller in check_arm_controllers and resp.state[i] == 'running':
                stop_controllers.append(controller)
        self.load_controller(new_controller)
        rospy.loginfo("[pr2_controller_switcher] Starting controller %s" % (start_controllers[0]) +
                      " and stopping controllers: [" + ",".join(stop_controllers) + "]")
        resp = self.switch_controller_srv(start_controllers, stop_controllers, 1)
        return resp.ok


