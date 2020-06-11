#!/usr/bin/python

import sys
import time
import json

import jsonrpclib

import broker
from jeenet.broker.core import DeviceProxy

#
#

host = "rpi"
server = jsonrpclib.Server('http://%s:8888' % host)

meter = DeviceProxy(server, "relaydev_7")

state = None

def on_msg(x):
    data = json.loads(x.payload)
    print "msg", data
    global state
    state = not state
    meter.set_relay(state)

def on_state(x):
    data = json.loads(x.payload)
    print "state", data
    global state
    state = data

mqtt = broker.Broker("uif", server="mosquitto")
mqtt.subscribe("uif/button/1", on_msg)
mqtt.subscribe("node/jeenet/7/relay", on_state)

mqtt.start()

while True:
    try:
        time.sleep(1)
    except KeyboardInterrupt:
        break

mqtt.stop()
mqtt.join()

# FIN
