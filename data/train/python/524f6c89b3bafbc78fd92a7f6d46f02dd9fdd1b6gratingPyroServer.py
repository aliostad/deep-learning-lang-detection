#!/usr/bin/env python
"""Create sinusoidal grating stimulus and allow control with gratingPyroGUI

"""

# Copyright (c) 2002-2003 Andrew Straw.  Distributed under the terms
# of the GNU Lesser General Public License (LGPL).

import VisionEgg
VisionEgg.start_default_logging(); VisionEgg.watch_exceptions()

from VisionEgg.Core import *
from VisionEgg.FlowControl import Presentation
from VisionEgg.Gratings import *
from VisionEgg.PyroHelpers import *

pyro_server = PyroServer()

# get visionegg stimulus ready to go
screen = get_default_screen()
stimulus = SinGrating2D()
viewport = Viewport(screen=screen,stimuli=[stimulus])
p = Presentation(viewports=[viewport])

# make a controller, serve it via pyro, and glue it to the Presentation
tf_controller = PyroConstantController(during_go_value=0.0)
pyro_server.connect(tf_controller,'tf_controller')
p.add_controller(stimulus,'temporal_freq_hz', tf_controller)

sf_controller = PyroConstantController(during_go_value=0.0)
pyro_server.connect(sf_controller,'sf_controller')
p.add_controller(stimulus,'spatial_freq', sf_controller)

contrast_controller = PyroConstantController(during_go_value=0.0)
pyro_server.connect(contrast_controller,'contrast_controller')
p.add_controller(stimulus,'contrast', contrast_controller)

orient_controller = PyroConstantController(during_go_value=0.0)
pyro_server.connect(orient_controller,'orient_controller')
p.add_controller(stimulus,'orientation', orient_controller)

duration_controller = PyroConstantController(during_go_value=(5.0,'seconds'))
pyro_server.connect(duration_controller,'duration_controller')
p.add_controller(p,'go_duration', duration_controller)

go_controller = PyroConstantController(during_go_value=0,eval_frequency=0)
pyro_server.connect(go_controller,'go_controller')
p.add_controller(p,'enter_go_loop', go_controller)

quit_controller = PyroConstantController(during_go_value=0)
pyro_server.connect(quit_controller,'quit_controller')
p.add_controller(p,'quit', quit_controller)

# get listener controller and register it
p.add_controller(None,None, pyro_server.create_listener_controller())

# initialize graphics to between presentations state
p.run_forever()
