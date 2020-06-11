#!/usr/bin/env python
from __future__ import absolute_import, division, print_function, unicode_literals

import threading

from WebInterface import WebInterface
from SlideshowController import SlideshowController
from Pi3DDisplayer import Displayer
#from DummyDisplayer import Displayer

controller = SlideshowController();
displayer = Displayer(controller.showQueue);
web = WebInterface(controller.configQueue);

# Run the controller, which controls the slide loading and transition timing.
controllerThread = threading.Thread(target=controller.run)
controllerThread.start();

# Run the web interface
#webThread = threading.Thread(target=web.run)
#webThread.daemon = True
#webThread.start();

# Finally, in this thread run the display loop.
displayer.run();