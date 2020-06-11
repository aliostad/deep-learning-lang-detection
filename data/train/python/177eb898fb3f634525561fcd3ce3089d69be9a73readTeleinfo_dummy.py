#!/usr/bin/env python

import sys
import getopt
import os
import time
import json
#import mosquitto

class TeleinfoOperations:
	CONST_TOPIC = '/bst/sensor/teleinfo/raw'
	
	def __init__(self, serialPort, broker):
		self.mqtt = broker


	def sendRecord(self, msg):
		dmsg = "%s -> %s" % (self.CONST_TOPIC, msg)
		print dmsg
#		self.mqtt.publish(self.CONST_TOPIC, msg)


	def run(self):		
		baseCnt = 127598
		while 1:
			try:
				time.sleep(1)
				trame = dict([["PAPP","2200"], ["IINST", "3"], ["BASE", str(baseCnt)]])

				baseCnt += 1
				
				if not os.path.exists('./stop'):
					self.sendRecord(json.dumps(trame))
				
			except KeyError:
				pass		


#define what happens after connection 
def on_connect(mosq, userdata, rc): 
	print "on_connect:"+str(rc) 

#On receipt of a log request 
def on_log(mosq, userdata, level, buf): 
	print "log: "+buf

def usage():
	print 'readTeleinfo [-l] -s <serialPort> -b <brokerAddress>'
 

serialPort = '/dev/ttyS0'
brokerAddress = 'localhost'


try:
	opts, args = getopt.getopt(sys.argv[1:],"hls:b:",["help", "log", "serial=","broker="])
except getopt.GetoptError as err:
	print err
	usage()
	sys.exit(2)

dolog=False
for opt, arg in opts:
	if opt in ("-h", "--help"):
		usage()
      		sys.exit()
	elif opt in ("-l", "--log"):
		dolog = True
	elif opt in ("-s", "--serial"):
		serialPort = arg
	elif opt in ("-b", "--broker"):
		brokerAddress = arg
	else:
            assert False, "unhandled option"


#create a broker 
#mqttc = mosquitto.Mosquitto("teleinfo_capture")  
mqttc = None

#define the callbacks 
#mqttc.on_connect = on_connect
if dolog:
	mqttc.on_log = on_log  

#connect 
#mqttc.connect(brokerAddress, 1883, 60)  

tiop = TeleinfoOperations('', mqttc)
tiop.run()
    

