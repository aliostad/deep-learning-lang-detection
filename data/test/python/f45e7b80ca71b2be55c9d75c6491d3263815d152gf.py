#!/usr/bin/python3
import sys
import urwid
import logging
import controller
from widgets.MainView import MainView

import concurrent.futures

logging.basicConfig(filename='log.log', level=logging.DEBUG)
logger = logging.getLogger(__name__)

directory = '.'
expr = sys.argv[1]

#processing_pool = concurrent.futures.ThreadPoolExecutor(max_workers=10)

controller.main_view = MainView()
controller.scan(directory)
controller.grep(expr)
controller.main_loop = urwid.MainLoop(controller.main_view, palette=[('reversed', 'standout', ''), ('matched', 'dark red', '')])

controller.main_loop.run()
