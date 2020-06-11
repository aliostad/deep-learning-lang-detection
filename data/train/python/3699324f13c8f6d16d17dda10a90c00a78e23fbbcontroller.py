#!/usr/bin/env python
import milight, datetime


controller = milight.MiLight({'host': '192.168.42.100', 'port': 8899}, wait_duration=.01)
light = milight.LightBulb(['white'])

def dawn():
	controller.send(light.brightness(30,4))
	controller.send(light.warmness(70,4))
	controller.send(light.brightness(30,1))
	controller.send(light.warmness(70,1))
	print("%s --- Lights set to dawn." % str(datetime.datetime.now()))

def sunrise():
        controller.send(light.brightness(100,4))
        controller.send(light.warmness(70,4))
	controller.send(light.brightness(100,1))
	controller.send(light.warmness(70,1))
	print("%s --- Lights set to sunrise." % str(datetime.datetime.now()))

def noon():
        controller.send(light.brightness(100,4))
        controller.send(light.warmness(30,4))
	controller.send(light.brightness(100,1))
	controller.send(light.warmness(30,1))
	print("%s --- Lights set to noon." % str(datetime.datetime.now()))

def sunset():
        controller.send(light.brightness(100,4))
        controller.send(light.warmness(100,4))
	controller.send(light.brightness(100,1))
	controller.send(light.warmness(100,1))
	print("%s --- Lights set to sunset." % str(datetime.datetime.now()))

def dusk():
        controller.send(light.brightness(40,4))
        controller.send(light.warmness(100,4))
	controller.send(light.brightness(40,1))
	controller.send(light.warmness(100,1))
	print("%s --- Lights set to dusk." % str(datetime.datetime.now()))

def night():
        controller.send(light.brightness(10,4))
        controller.send(light.warmness(100,4))
	controller.send(light.off(1))
	#controller.send(light.warmness(100,1))
	print("%s --- Lights set to night." % str(datetime.datetime.now()))
