#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initalize python script to start the main programm
You have to configure the settings.json before and execute the beforeStart.sh -Shell Script
(sudo ./beforeStart.sh)
"""
import RPi.GPIO as GPIO
import json
from mqttClient import mqttClient
import paho.mqtt.client as mqtt

GPIO.setmode(GPIO.BOARD)


with open('settings.json') as data_file:
        settingsdata = json.load(data_file)        

brokerAddress = str(settingsdata["ip"])
brokerPort = str(settingsdata["port"])
systemID = settingsdata["systemid"]

client = mqttClient()
clientInstance = client.initalize(systemID)
client.connect(clientInstance,brokerAddress, brokerPort)
client.subscribe(clientInstance)

client.react(clientInstance)


    
