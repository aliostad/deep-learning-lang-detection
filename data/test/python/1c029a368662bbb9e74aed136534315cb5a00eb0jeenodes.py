#!/usr/bin/python -u

import time
import sys
import os
import optparse
import datetime
from threading import Thread

from system.core import Device, Broker, Clock, log, run_threads, kill_threads, get_device, on_new_device
from system.jeenet import JeeNodeDev, JeeNet, Gateway, message_info, Monitor
from system.jsonrpc import JsonRpcServer
from system.iot import IoT
from system.mqttrpc import MqttRpc
from system.mqtt import Mqtt

from devices.pir import PirSensor
from devices.triac import Triac
from devices.humidity import HumidityDev
from devices.voltage import VoltageDev
from devices.relay import RelayDev
from devices.magnetometer import MagnetometerDev
from devices.pulse import PulseDev

arduino = "/dev/arduino"
if not os.path.exists(arduino):
    arduino = "/dev/ttyACM0"

p = optparse.OptionParser()
p.add_option("-d", "--device", dest="device", default=arduino)
p.add_option("-v", "--verbose", dest="verbose", action="store_true")
p.add_option("-i", "--iot", dest="iot", action="store_true")
p.add_option("-m", "--mqtt", dest="mqtt")
p.add_option("-b", "--broker", dest="broker")
opts, args = p.parse_args()
print opts, args

dev = opts.device
verbose = opts.verbose

#
#

class TestDev(PirSensor):

    def get_poll_period(self):
        return None

#
#   Known device types

known_devices = {
    "Test Device v1.0" : TestDev, # TODO
    "Humidity Device v1.0" : HumidityDev,
    "Voltage Monitor v1.0" : VoltageDev,
    "Triac Control v1.0" : Triac,
    "PIR Device v1.0" : PirSensor,
    "Relay Device v1.0" : RelayDev,
    "Magnetometer v1.0" : MagnetometerDev,
    "Pulse Detector v1.0" : PulseDev,
}

#
#   Handle unregistered Devices

class UnknownHandler:

    def __init__(self, network, broker, monitor):
        self.network = network
        self.broker = broker
        self.monitor = monitor

    def add_device(self, node, data, info):
        log("add_device", info)
        dev = info.get("device")
        if not dev in known_devices:
            return False

        klass = known_devices[dev]
        name = "%s_%d" % (klass.__name__.lower(), node)
        log("Added device", name)
        d = klass(dev_id=node, node=name, network=self.network, broker=self.broker)
        d.description = dev
        d.on_net(node, data)
        return True

    def on_device(self, node, data):
        fields = [
            (JeeNodeDev.text_flag, "device", "p"),
        ]
        try:
            msg_id, flags, info = message_info(data, JeeNodeDev.fmt_header, fields)
        except TypeError:
            info = { "data" : `data` }

        if self.add_device(node, data, info):
            return

        info["error"] = "unknown device"
        info["why"] = info.get("device", "message received")
        self.broker.send("unknown_node_%d" % node, info)

#
#

runners = []

# make a jeenet reader
jeenet = JeeNet(dev=dev, verbose=verbose)
runners.append(jeenet)

broker = Broker(verbose=True)
runners.append(broker)

clock = Clock(node="tick", broker=broker, period=0.1)
runners.append(clock)

js = JsonRpcServer(name="json", broker=broker, port=8888)
runners.append(js)

# Monitor handles pinging any nodes and monitoring if they are down
monitor = Monitor(node="monitor", broker=broker, period=10, dead_time=20)
runners.append(monitor)

# Handle any unknown devices that message the gateway
unknown = UnknownHandler(jeenet, broker, monitor)
jeenet.register(-1, unknown.on_device)

if opts.iot:
    iot = IoT(name="iot", broker=broker, server="klatu")
    runners.append(iot)

    # Need a way of adding devices to IoT reporting
    def report_to_iot(node, dev):
        iot.forward(dev.node)

    on_new_device(report_to_iot)

on_new_device(monitor.on_new_device)

# construct the gateway device
gateway = Gateway(dev_id=31, node="gateway", network=jeenet, broker=broker, verbose=verbose)

on_new_device(gateway.on_new_device)
jeenet.register(-1, gateway.on_unknown_device)

# open the networks
jeenet.open()
jeenet.reset()

# Add MQTT RPC

if opts.mqtt:
    rpc = MqttRpc(opts.mqtt, "rpc/jeenet")
    runners.append(rpc)

# MQTT output

if opts.broker:
    mqtt = Mqtt(opts.broker, broker)
    on_new_device(mqtt.on_new_device)
    runners.append(mqtt)

# start the threads
threads = run_threads(runners)

while True:
    try:
        time.sleep(1)
    except KeyboardInterrupt:
        break

log("killing ...")
kill_threads(threads)

# FIN
