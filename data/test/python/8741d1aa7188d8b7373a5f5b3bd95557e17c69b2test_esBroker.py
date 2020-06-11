#!/usr/bin/python

from Queue                import Empty as QueueEmpty
from multiprocessing      import Queue
from random               import choice

from geoip2.database      import Reader

from lib.types.nameserver import NameServer
from lib.types.node       import Node
from lib.bots.esBroker    import esBroker
from lib.bots.dnsBroker   import dnsBroker

qin, eqout, sqout, metaQin, metaQout = Queue(), Queue(), Queue(), Queue(), Queue()

LOG   = 'var/log/test_esBroker.log'
geoip = Reader( "/usr/share/geoip/GeoLite2-City.mmdb" )


def targeting():
    for i in range( 149, 150 ):
        #range( 125,150 ):
        qin.put( Node( a_records = [ "96.126.107.{}".format( i ) ] ) )

targeting()
qin.put( "STOP" )

db  = dnsBroker( 0, LOG, NameServer(), qin = qin, eqout = eqout, sqout = sqout, 
                 metaQin = metaQin, metaQout = metaQout, geoip = geoip ) 

db.background()
print 'dnsb done'
eqout.put( 'STOP' )
import pdb; pdb.set_trace()
es  = esBroker( 1, LOG, qin = eqout, metaQin = metaQin, metaQout = metaQout, geoip = geoip )
es.background()
