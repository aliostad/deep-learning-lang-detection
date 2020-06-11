#!/usr/bin/python
import os
import sys
import tty
import json
import time
import subprocess
import urllib
import urllib.request
import urllib.parse
import mosquitto

class CodeSounds:
    _error_wait_time = 3

    def __init__(self, broker, config_path):
        self._broker = broker

        config_file = open(config_path, 'r')
        config_str = config_file.read()
        config_file.close()

        self._config = json.loads(config_str)

        self._connect_to_broker()

    def _connect_to_broker(self):
        try:
            print('Connecting to broker.')

            self._client = mosquitto.Mosquitto('code_sounds')

            self._client.on_connect = self.on_connect
            self._client.on_disconnect = self.on_disconnect
            self._client.on_subscribe = self.on_subscribe
            self._client.on_message = self.on_message

            self._client.connect(self._broker, 1883, 60)

            self._client.subscribe("hasi/code_scanner", 0)
        except:
            print('Could not connect to broker. Trying again in a few seconds.')

            time.sleep(self._error_wait_time)
            self._connect_to_broker()

    def on_connect(self, mosq, obj, rc):
        print('Connected to the broker.')

    def on_disconnect(self, mosq, obj, rc):
        print('Disconnected from the broker. Reconnecting now.')

        self._connect_to_broker()

    def on_subscribe(self, mosq, obj, mid, qos_list):
        print('Subscribed to the topic.')

    def on_message(self, mosq, obj, msg):
        code = msg.payload.decode('utf-8')

        if code in self._config:
            self.play_sound(self._config[code])

    def play_sound(self, path):
        subprocess.Popen(['aplay', path])

    def loop(self):
        try:
            for i in range(6000):
                self._client.loop(10)

            self._client.disconnect()
            self._connect_to_broker()
        except:
             print('Fatal error. Trying to reconnect to the scanner.')

             time.sleep(self._error_wait_time)
             self._connect_to_broker()

if __name__ == '__main__':
    code_sounds = CodeSounds('atlas.hasi', 'sounds.conf')
    
    while True:
        code_sounds.loop()
