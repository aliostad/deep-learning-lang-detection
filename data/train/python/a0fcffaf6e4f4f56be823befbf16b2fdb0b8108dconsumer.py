import sys

from twisted.python import log
from twisted.internet import reactor

from autobahn.twisted.websocket import connectWS

from autobahn.wamp1.protocol import WampClientFactory, \
                                    WampClientProtocol
import argparse
import requests
import json
import os
import datetime
import time
import constants

brokers_list = []
use_xy = True
# current_brokers = 0
# max_brokers = 0

class SensorDataConsumerClientProtocol(WampClientProtocol):
   """
   Protocol for the sensor data consumer client. Uses WAMP protocol.
   """

   def onSessionOpen(self):
      print "Connected to ", wsuri
      # reactor.callLater(constants.REDISCOVERY_INTERVAL, rediscover_brokers, current_brokers=global.current_brokers, max_brokers=global.max_brokers)

      def default_response(topic, event):
         print "Received event: ", topic, event
      
      def save_to_file(topic, event):
         io_file.write(str(str(event['sensor']) + "," + event['lat']) + "," + str(event['lng']) + "," + str(event['data']) + "," + str(event['timestamp']) + "," + str((datetime.datetime.now() - datetime.datetime.strptime(event['timestamp'], "%Y-%m-%d %H:%M:%S.%f")).total_seconds()) + "\n")
         io_file.flush()
      for sensor in sensors.split(","):
         self.subscribe(sensor, save_to_file)


      # def rediscover_brokers(current_brokers, max_brokers):
      #    if (current_brokers < max_brokers):
      #       if (use_xy):
      #          broker_list = request_brokers_xy(registry_address, lat, lng, radius, max_brokers, sensors)
      #       else:
      #          broker_list = request_brokers_l(registry_address, location, radius, max_brokers, sensors)
      #       update_broker_list();

      # def update_broker_list():
      #    for broker in broker_list:
      #       wsuri = broker['broker_address']
      #       print "Connecting to", wsuri
      #       factory = WampClientFactory(wsuri, debugWamp = False)
      #       factory.protocol = SensorDataConsumerClientProtocol
      #       connectWS(factory)

def request_broker_address(registry_address,location):
   """Request one broker"""
   payload = {'location': location}
   req = requests.get(registry_address+"/request_broker", params=payload)
   response_json = req.text
   response = json.loads(response_json)
   return response["broker_address"]

def request_brokers_l(registry_address, location, radius, max_brokers, sensors):
   """Request a list of up to max_brokers brokers based on a location string (e.g. "Moscow")"""
   payload = {'location': location, 'max_brokers' : max_brokers, 'radius' : radius, 'sensors' : sensors}
   req = requests.get(registry_address + "/request_brokers", params=payload)
   response_json = req.text
   response = json.loads(response_json)
   return response

def request_brokers_xy(registry_address, lat, lng, radius, max_brokers, sensors):
   """Request a list of up to max_brokers brokers based on coordinates"""
   payload = {'lat': lat, 'lng' : lng, 'max_brokers' : max_brokers, 'radius' : radius, 'sensors' : sensors}
   try: 
      req = requests.get(registry_address + "/request_brokers", params=payload) 
      response_json = req.text
      response = json.loads(response_json)
      return response
   except requests.exceptions.RequestException:
      print "Trying to get the broker again"
      time.sleep(0.5)
      request_brokers_xy(registry_address, lat, lng, radius, max_brokers, sensors)


if __name__ == '__main__':
   log.startLogging(sys.stdout)
   
   # Deal with command line arguments
   parser = argparse.ArgumentParser()
   parser.add_argument('-r', '--registry', type=str)
   parser.add_argument('-s', '--sensors', type=str)
   parser.add_argument('-l', '--location', type=str)
   parser.add_argument('-b', '--maxbrokers', type=int)
   parser.add_argument('-d', '--radius', type=int)
   parser.add_argument('-x', '--lat', type=str)
   parser.add_argument('-y', '--lng', type=str)
   parser.add_argument('-o', '--outputfilename', type=str)

   args = parser.parse_args()

   sensors = args.sensors
   location = args.location
   lat = args.lat
   lng = args.lng
   registry_address = args.registry
   max_brokers = args.maxbrokers
   radius = args.radius
   output = args.outputfilename

   ## loops through brokers in broker list, connecting to each
   if (location != None):
      use_xy = False
      broker_list = request_brokers_l(registry_address, location, radius, max_brokers, sensors)
   else:
      if (lat == None or lng == None):
         print "ERROR - must have either location (-l) or latitude (-x) and longitude (-y)"
         exit()
      use_xy = True
      broker_list = request_brokers_xy(registry_address, lat, lng, radius, max_brokers, sensors)

   print "BROKER LIST : " + str(broker_list)
   if (broker_list):
      io_file = open("output/" + output + ".csv", 'w+')
      io_file.write("sensor,lat,lng,data,timestamp,time\n")
      for broker in broker_list:
         wsuri = broker['broker_address']
         print "Connecting to", wsuri
         factory = WampClientFactory(wsuri, debugWamp = False)
         factory.protocol = SensorDataConsumerClientProtocol
         connectWS(factory)
      
      reactor.run()
