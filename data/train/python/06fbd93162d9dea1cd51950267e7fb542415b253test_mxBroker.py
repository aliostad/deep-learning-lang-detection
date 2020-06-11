#!/usr/bin/python

from Queue                import Empty as QueueEmpty
from multiprocessing      import Queue
from random               import choice
from geoip2.database      import Reader

from lib.types.node       import Node
from lib.types.nameserver import NameServer
from lib.bots.mxBroker    import mxBroker 
from lib.bots.dnsBroker   import dnsBroker

qin, sqout, eqout, metaQin, metaQout = Queue(), Queue(), Queue(), Queue(), Queue()

geoip = Reader( '/usr/share/geoip/GeoLite2-City.mmdb' )

dns = dnsBroker( 1, 'var/log/test_mxBroker.log', NameServer(), qin = qin, metaQin = metaQin, metaQout = metaQout, geoip = geoip ) 
mx  = mxBroker(  0, 'var/log/test_mxBroker.log', qin = qin, metaQin = metaQin, metaQout = metaQout, geoip = geoip )

import pdb; pdb.set_trace()
node = dns.build_host( Node( url = 'darchoods.net' ) )
mx.process( node )

