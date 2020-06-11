import paho.mqtt.client as mqttc
import argparse

argumentParser = argparse.ArgumentParser("execute_sql_files")

argumentParser.add_argument('--brokerAddress', 
							required=True,
			                help="IP address of MQTT broker for topic")

argumentParser.add_argument('--brokerPort', 
							required=True,
			                help="Port number of MQTT broker for topic")

argumentParser.add_argument('--topic', 
							required=True,
			                help="Topic to monitor")

arguments = argumentParser.parse_args()

client = mqttc.Client()

def onConnect (client, userData, rc):
	client.subscribe(arguments.topic)

def onMessage(client, userdata, msg):
	print msg.payload

client.on_connect = onConnect
client.on_message = onMessage
client.will_set("services.event.dropped", "Sorry, I seem to have died")

try:
	client.connect(arguments.brokerAddress, arguments.brokerPort, 60)
except Exception, e:
	print "Error: " + str(e)

