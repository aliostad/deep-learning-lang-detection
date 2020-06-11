
#
# Proxy client in Python
# Connects REQ socket to tcp://localhost:5555
# Sends "Hello" to server, expects "World" back
#
import zmq
import zhelpers
import aserver_scale1 as aserver

context = zmq.Context()

# Socket to talk to server
print "Cli: Connecting to hello world server..."

waiting = context.socket( zmq.REQ )
waiting.connect( aserver.WAI_URL )

broker = context.socket( zmq.REQ )
broker.connect( aserver.BRO_URL )

print "Cli: HWM: %d, ID: %r" % (
    broker.getsockopt(zmq.HWM), broker.getsockopt(zmq.IDENTITY ))
# Do 10 requests, waiting each time for a response
for request in range (1,10):
    print "Cli: Getting a server..."
    waiting.send_multipart( [ 'WAITING' ] )
    server = waiting.recv_multipart()

    print "Cli: Sending request %s via [%s]" % (
        request, 
        ", ".join( [ zhelpers.format_part( msg ) for msg in server ] ))

    broker.send_multipart( [ server[-1], 'Hello' ] )
    multipart = broker.recv_multipart()
    print "Cli: Received reply %s: [%s]" % (
        request,
        ", ".join( [ zhelpers.format_part( msg ) for msg in multipart ] ))
