#!/usr/bin/python
# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
import os
import sys

if __name__ == '__main__':
    sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../utils'))

import websocket

def main():
    gameId = 'abc123'
    controllerId = '90210'

    displayWS = websocket.WebSocket()
    displayWS.connect("ws://127.0.0.1:8887/%s/display" % gameId)

    controllerWS = websocket.WebSocket()
    controllerWS.connect("ws://127.0.0.1:8887/%s/controller/%s" % (gameId, controllerId))

    displayWS.send('%s show controller welcome screen' % controllerId)
    controllerWS.send('please accept this gesture')

    print 'DISPLAY GOT:', displayWS.recv()
    print 'CONTROLLER GOT:', controllerWS.recv()

    displayWS.close()
    controllerWS.close()

if __name__ == '__main__':
    main()
