#!/usr/bin/python
# Copyright (c) 2014,All rights reserved.
# This shows an example of using the publish.single helper function.

import sys
import os
import time

#MQTT Initialize.=======================
try:
    import paho.mqtt.publish as publish
except ImportError:
    # If you have the module installed, just use "import paho.mqtt.publish"
    import os
    import inspect
    cmd_subfolder = os.path.realpath(os.path.abspath(os.path.join(os.path.split(inspect.getfile( inspect.currentframe() ))[0],"../src")))
    if cmd_subfolder not in sys.path:
        sys.path.insert(0, cmd_subfolder)
    import paho.mqtt.publish as publish

#========================================
strChannel = "/inode/info"

print "Pulish to channel:", strChannel     

#Using Mosquitto MQTT Borker.
#Local Server.
#strBroker = "localhost"

#Lan Server.
strBroker = "192.168.12.25"

#public server by SMI.
#strBroker = "112.124.67.178"

#test server by eclipse funds.
#strBroker = "m2m.eclipse.org"

#for i in range(0,100):
publish.single(strChannel, "translate geoimage...", hostname = strBroker)
publish.single(strChannel, "upload to server...", hostname = strBroker)

#time.sleep(1)
