#! /usr/bin/env python

import logging
from controller import Controller
import json


if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
    logging.info('Reading configuration')

    with open('logicdata.json') as data_file:    
        objects = json.load(data_file)

    controller = Controller();

    for o in objects:
        controller.registerLogic(o[:], objects[o])

    try:
        controller.start()
    except KeyboardInterrupt:
        logging.info("Stopping")
        controller.shutdown()
    except Exception, msg:
        logging.debug(msg)
