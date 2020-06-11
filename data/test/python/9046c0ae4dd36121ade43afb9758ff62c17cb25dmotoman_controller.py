#!/usr/bin/python

import rospy

from task_controller.MotomanController import MotomanController
from task_controller.Scheduler import ResettableScheduler
from apc_util.services import wait_for_services
from task_controller.srv import SetSchedule, SetScheduleResponse

scheduler = ResettableScheduler()


def set_schedule_callback(req):
    scheduler.set_schedule(req.schedule)
    return SetScheduleResponse(True)


if __name__ == '__main__':
    rospy.init_node("motoman_controller")

    wait_for_services()

    rospy.Service('set_schedule', SetSchedule, set_schedule_callback)

    controller = MotomanController(scheduler)

    controller.Start()
