# MQTT python example using free broker Eclipse IoT
# Based on example from https://eclipse.org/paho/clients/python/
#
# If the message received starts with "speak ", it uses espeak to reproduce the
# rest of the message.
#
# Requires:
#  * paho-mqtt module (https://github.com/eclipse/paho.mqtt.python)
#  * espeak
# Tested on OrangePi Mini running Ubuntu 16.04 (Armbian)
#
# MyMQTT Android app or MQTTlens Chrome extension can be used to access IoT
# following the configs below.

import shlex, subprocess
import sys
import paho.mqtt.client as mqtt

# configuration to access IoT
broker = "iot.eclipse.org"
broker_port = 1883
broker_keepalive = 60
topic = "OPiMiniMQTT17"

espeak_call = "/usr/bin/espeak"
espeak_args = "-vpt+f1 -p 60"

def speak_message(msg_str):
    cmd = " ".join([espeak_call, espeak_args, "'"+msg_str+"'"])
    print "Executing cmd '%s'" % cmd
    args = shlex.split(cmd)
    try:
        subprocess.Popen(args)
    except:
        print "Error occurred when trying to call '%s'" % cmd

def on_connect(client, userdata, flags, rc):
    print "Connected to the broker '%s' (rc %s)" % (broker, str(rc))
    client.subscribe(topic)
    print "Subscribed to '%s'" % (topic)

def on_message(client, userdata, msg):
    msg_str = str(msg.payload)
    print "Message received from topic '%s': '%s'" % (msg.topic, msg_str)
    if msg_str.startswith("speak "):
        speak_message(msg_str.replace("speak ",""))

def main():
    try:
        print "Initializing..."
        client = mqtt.Client()
        client.on_connect = on_connect
        client.on_message = on_message

        client.connect(broker, broker_port, broker_keepalive)
        client.loop_forever()
    except KeyboardInterrupt:
        print "Ctrl+C was pressed. Exiting..."
        sys.exit(0)

if __name__ == '__main__':
    main()
