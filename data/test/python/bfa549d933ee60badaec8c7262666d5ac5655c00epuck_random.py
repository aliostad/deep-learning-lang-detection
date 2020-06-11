from epuck import EpuckFunctions
import os,re,time,random,math,pprint
import numpy

epuck_controller = EpuckFunctions()
epuck_controller.basic_setup()
while True:
    # epuck_controller.stop_moving()
    epuck_controller.update_proximities()
    epuck_controller.step(200)
    epuck_controller.move_wheels([numpy.sum(epuck_controller.dist_sensor_values[4:8])/250,numpy.sum(epuck_controller.dist_sensor_values[0:4])/250])
    epuck_controller.step(200)
    print "Distance sensors:"
    pprint.pprint(epuck_controller.dist_sensor_values)

