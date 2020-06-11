#!/usr/bin/env python

#
#    MythTV-InfoScreen - long poll server giving MythTV information
#
#    Copyright (C) 2012 Andy Boff
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

from LongPollServer import *
from MessageQueue import *
from ChannelProviders import *
from ConnectionProviders import *
import time
import re
import os, sys
import gevent
import signal

def finish():
    print "Shutting down webserver"
    server.shutdown()
    
    print "Shutting down data providers"
    for p in providers:
        p.shutdown()
    
    print "Shutting down message broker"
    broker.shutdown()
    
    print "Shutting external connections"
    for c in connections.keys():
        conn = connections[c]
        conn.shutdown()

    sys.exit(0)

# Create providers of information/data authorities, etc.
print "Establishing connections..."
connections = {
  'MythTV': MythTVConnection(),
  'StateTable': StateTable()
}

# Create the message broker framework
print "Building message broker..."
broker = MessageBroker()

# Create the classes which provide the channels into the broker
print "Building channel providers..."
providers = [
  TimeProvider(broker),
  MythRecordingProvider(broker, connections['MythTV']),
  MythUpcomingProvider(broker, connections['MythTV']),
  StateTableProvider(broker, connections['StateTable'])
]

myScript = sys.argv[0]
myDir = os.path.dirname(myScript)

myIp = '127.0.0.1'
myPort = 1234
if len(sys.argv) > 2:
    myIp = sys.argv[1]
    myPort = int(sys.argv[2])

# Create the webserver class, and its various request handler classes.
server = WebServer(myIp, myPort, [
  StaticFileHandler(  re.compile('^/static/(.*)$'),                       os.path.join(myDir, 'html')),
  PushMessageChannel( re.compile('^/channel/longpoll/(.*)$'),             broker),
  RegisterHandler(    re.compile('^/channel/register/(.*)$'),             broker),
  SubscribeHandler(   re.compile(r'^/channel/subscribe/([\w\.]+)/(.*)$'), broker),
  RedirectHandler(    re.compile('^/\w*$'),                               '/static/index.html'),
  InfoHandler(        re.compile('^/info/(.*)$'),                         broker, connections),
  RandomImageHandler( re.compile('^/image/random$'),                      os.path.join(myDir, 'img'), os.path.join(myDir, 'imgDefault')),
  StateTableHandler(  re.compile('^/state/(\w+)/(.*)$'),                  connections['StateTable']),
  RefreshHandler(     re.compile('^/refresh/(.+)'),                       broker),
  DebugChannelHandler(re.compile('^/debug/channel/([\w+\.]+)/(\d)$'),     broker)
])

gevent.signal(signal.SIGTERM, finish)
keepRunning = True
while keepRunning:
    try:
        time.sleep(10)
    except KeyboardInterrupt:
        print "Interrupt detected. Shutting down."
        keepRunning = False

finish()
