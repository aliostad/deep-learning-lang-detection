# -*- coding: utf-8 -

__author__ = 'eric'

from mqtt.mqttclient import MQTTWSClient

from flask import Flask, request, render_template, session, abort, json

from flask_login import login_required
from geventwebsocket import WebSocketServer, WebSocketError

from dashbin import app, login_manager

@login_required
@app.route('/mqtt')
def mqtt2ws():

    def loop():
        """ websocket loop
        """
        topic = None
        mqtt_clients = []

        while True:
            try:
                message = ws.receive()

                if message:
                    try:
                        msg = json.loads(message)
                    except:
                        #TODO: send error to client
                        continue
                    else:
                        if msg.has_key("subscribe"):

                            topic = msg["topic"]
                            mqtt_broker = msg["broker"]
                            chart_uuid = msg["uuid"]

                            if msg not in mqtt_clients:
                                # spawn mqtt_client
                                mqtt_clients.append(msg)
                                mqtt_client = MQTTWSClient(ws, chart_uuid, broker=mqtt_broker)
                                mqtt_client.start()
                                mqtt_client.subscribe(topic)
                            #
                            #         mqtt_clients[mqtt_broker][topic] = mqtt_client
                            # try:
                            #     if not mqtt_clients.has_key(mqtt_broker):
                            #         # spawn mqtt_client
                            #         mqtt_clients[mqtt_broker] = {}
                            #
                            #     if not mqtt_clients[mqtt_broker].has_key(topic):
                            #         mqtt_client = MQTTWSClient(ws, chart_uuid, broker=mqtt_broker)
                            #         mqtt_client.start()
                            #
                            #         mqtt_clients[mqtt_broker][topic] = mqtt_client
                            #
                            #     mqtt_client[mqtt_broker][topic].subscribe(topic)
                            #
                            # except:
                            #     # we're unable to subscribe to the topic
                            #     #TODO: send error to client
                            #     continue
                            # else:
                            #     pass
                        else:
                            pass

                # send a websocket ping to client
                ws.send('{"object": "ping"}')

            except WebSocketError:
                # Possibility to execute code when connection is closed
                print "Socket closed"
                # global mqtt_client
                if mqtt_client:
                    mqtt_client.cleanup()
                break

    ws = request.environ.get('wsgi.websocket')

    if not ws:
        abort(400, "Expected WebSocket request")
    else:
        loop()
