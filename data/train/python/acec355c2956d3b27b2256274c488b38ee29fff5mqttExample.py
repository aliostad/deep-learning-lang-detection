#!/usr/bin/python
#
# simple script to repeatedly publish an MQTT message
#
# pip install paho-mqtt

import paho.mqtt.client as paho
import os
import time

broker = "localhost"
port = 1883
topic = "menu_crous_17"

mypid = os.getpid()
pub= "pubclient_"+str(mypid)
mqttc = paho.Client(pub, False) #nocleanstart
 
#connect to broker
mqttc.connect(broker, port, 60)
 
#remain connected and publish
while mqttc.loop() == 0:
    msg = "test message "+time.ctime()
    mqttc.publish(topic, msg, 0, True) #qos=0, retain=y
    print "message published"
    time.sleep(1.5)
    pass


