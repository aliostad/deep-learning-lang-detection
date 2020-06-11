#!/usr/bin/python 
# -*- coding: utf-8 -*- 
#
# Copyright (c) 2013 ASMlover. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#  * Redistributions of source code must retain the above copyright
#    notice, this list ofconditions and the following disclaimer.
#
#    notice, this list of conditions and the following disclaimer in
#  * Redistributions in binary form must reproduce the above copyright
#    the documentation and/or other materialsprovided with the
#    distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

import sys
import time
import random
import threading
import zmq



def worker_routine():
  thread_name = threading.currentThread().getName()
  ctx = zmq.Context()
  worker = ctx.socket(zmq.REQ)
  worker.setsockopt(zmq.IDENTITY, thread_name)
  worker.connect('tcp://localhost:5555')

  print 'worker [%s] init success ...' % thread_name
  total = 0
  random.seed()
  while True:
    worker.send('Hi Boss')
    workload = worker.recv()
    if workload == 'Fired!':
      print 'worker [%s] completed: %d tasks' % (thread_name, total)
      break
    total += 1
    
    time.sleep(random.randint(1, 1000) * 0.0001)

  worker.close()



if __name__ == '__main__':
  if (len(sys.argv) < 2):
    print 'arguments error ...'
    exit()
  
  ctx = zmq.Context()
  broker = ctx.socket(zmq.ROUTER)
  broker.bind('tcp://*:5555')

  for _ in range(int(sys.argv[1])):
    threading.Thread(target=worker_routine, args=()).start()
  
  for _ in range(int(sys.argv[1]) * 50):
    addr = broker.recv()
    empty = broker.recv()
    ready = broker.recv()

    broker.send(addr, zmq.SNDMORE)
    broker.send('', zmq.SNDMORE)
    broker.send('this is the workload')

  for _ in range(int(sys.argv[1])):
    addr = broker.recv()
    empty = broker.recv()
    ready = broker.recv()

    broker.send(addr, zmq.SNDMORE)
    broker.send('', zmq.SNDMORE)
    broker.send('Fired!')


  broker.close()
