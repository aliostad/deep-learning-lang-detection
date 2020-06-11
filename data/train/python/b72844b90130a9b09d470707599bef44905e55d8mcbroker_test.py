import threading
import zmq
import zhelpers
import mcbroker

broker_urls		= [ mcbroker.BRO_URL ]

'''
# Test doesn't clean up all sockets; Context won't exit cleanly...
def test_client_simple():
    """
    This is a test of a simple client-broker session allocation
    """
    context		= zmq.Context()
    broker_threads	= mcbroker.demo_broker_servers( context, 10 )

    # Connect to all brokers
    broker		= context.socket( zmq.REQ )
    broker.setsockopt( zmq.RCVTIMEO, 250 )
    for url in broker_urls:
        broker.connect( url )

    session 		= None
    # Get a session key and url
    broker.send_multipart( [ '' ] )
    try:
        # 1) Obtain a session key and url from the broker.
        key, url 	= broker.recv_multipart()

        # 2) Attach to the session URL, and send one or more commands
        session		= context.socket( zmq.REQ )
        session.setsockopt( zmq.RCVTIMEO, 1250 )
        session.connect( url )

        # 2a) A session command contains the key and the remainder of the command
        # 'Hello' --> 'World'
        session.send_multipart( [key, 'Hello'] )
        response	= session.recv_multipart()
        assert len( response ) == 3
        assert response[0] == key
        assert response[1] == 'Hello'
        assert response[2] == 'World'

        # 3) Release the session key
        session.send_multipart( [key] )
        ack		= session.recv_multipart()
        assert len( ack ) == 1
        assert ack[0] == key

    finally:
        if session:
            print "%s Tst: Closing session connection" % ( mcbroker.timestamp() )
            session.close()

        broker.send_multipart( [ 'HALT' ] )

        for t in broker_threads:
            print "%s Tst: Joining %s" % ( mcbroker.timestamp(), t )
            t.join()

        print "%s Tst: Closing broker connection" % ( mcbroker.timestamp() )
        broker.close()
        print "%s Tst: Terminating context" % ( mcbroker.timestamp() )
        context.term()
'''
