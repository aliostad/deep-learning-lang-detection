#!/usr/bin/env python
import time
import os
import os.path
import logging
import logging.handlers
import pprint
from copy import deepcopy

#Need a more complex logging
logging.basicConfig(level=logging.INFO)

if os.name == "nt":
    log_filename = "D:\\toys\\controller\\controller.log"
else:
    log_filename = os.path.expanduser("~/.controller/controller.log")

fh = logging.handlers.RotatingFileHandler(log_filename,
                                          maxBytes=1024*128,
                                          backupCount=15)
logging.getLogger('').addHandler(fh)

from controller import Controller, make_now,monkey_program
import controller_settings

if __name__ == "__main__":
    now = make_now()
    odd_even = now["day"] % 2 == 0
    if odd_even:
        odd_even = "even"
    else:
        odd_even = "odd"
    print "Toy Simulation"
    print "Toy Program"
    controller = Controller()
    monkey_program(controller.programs[1], 20)
    pprint.pprint(controller.programs[1])
    monkey_program(controller.programs[2], 160)
    pprint.pprint(controller.programs[2])
    monkey_program(controller.programs[3], 200)
    pprint.pprint(controller.programs[3])
    controller.prepare_programs()
    print len(controller.programs.keys())
    i = 0
    controller.add_single_station_program(6, 7)
    pprint.pprint(controller.one_shot_program)

    program = deepcopy(controller_settings.station_template)
    sd = deepcopy(controller_settings.station_duration_template)
    program[controller_settings.STATION_DURATION_KEY].append(sd)
    sd[controller_settings.STATION_ID_KEY] = 3
    sd[controller_settings.DURATION_KEY] = 500

    controller.add_new_program(program)
