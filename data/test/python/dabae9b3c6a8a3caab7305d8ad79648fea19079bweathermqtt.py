#!/usr/bin/python
#import mosquitto
import paho.mqtt.client as mqtt
import os
import time
import re
import sys
import signal
import urllib
import json


def signal_handler(signal, frame):
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

broker = "192.168.1.3"
tcpport = 1883
topic = "house/temp/outside"
url = "http://jonarcher.info/weather-data"

mqttc = mqtt.Client()
#Connect to broker
#mqttc.connect(broker, tcpport, 60, True)
mqttc.connect (broker, tcpport, 60)
mqttc.loop_start()
while True:

	response = urllib.urlopen(url);
	data = json.loads(response.read())
	#print data
	#json_data=open(file)
	#data = json.load(json_data)
	temp = data["temperature"]
	mqttc.publish(topic,temp, retain=True)
	time.sleep(30)

mqttc.loop_forever()
