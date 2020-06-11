#!/usr/bin/env python3

import zmq
from time import sleep
from random import randint


if __name__ == '__main__':

    context = zmq.Context()
    
    broker = zmq.Socket(context, zmq.ROUTER)
    broker.bind("tcp://*:1780")

    while True:
        identity = broker.recv_string()
        print("RECV: " + identity)
        broker.send_string(identity, zmq.SNDMORE)
        broker.send_string('', zmq.SNDMORE)
        broker.send_string(hex(randint(0, 0x10000)))
        sleep(2)

    broker.close()
    context.destroy()



