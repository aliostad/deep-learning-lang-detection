import roslib;
roslib.load_manifest( 'nao_core' );
import rospy;

import sys;

# Importing NaoQi.
try:
    from naoqi import ALBroker, ALProxy;
except ImportError, e:
    rospy.logerr( 'Unable to import NaoQi, make sure it is present in the $PYTHONPATH.' );
    sys.exit( 1 );
    
from NaoBroker import NaoBroker;

class NaoNode( object ):
    """
    NaoNode
    """
    broker = None;

    def __init__( self ):
        # Get the connection info from the command line.
        from argparse import ArgumentParser;
        
        parser = ArgumentParser();
        parser.add_argument( '--pip', dest = 'parentIp', default = '127.0.0.1', 
                             help = 'IP address of the parent broker (default is 127.0.0.1).' );
        parser.add_argument( '--pport', dest = 'parentPort', default = 9559, 
                             help = 'Port of the parent broker (default is 9559).' );
        
        args = parser.parse_known_args()[ 0 ]; # Since it returns a tuple.
        
        self.parentIp = args.parentIp;
        self.parentPort = int( args.parentPort );
        
        # Connect to the broker.
        self.broker = NaoBroker( self.parentIp, self.parentPort );
    
    def getProxy( self, name ):
        proxy = None;
        
        try:
            proxy = ALProxy( name, self.parentIp, self.parentPort );
        except RuntimeError, e:
            rospy.logerr( 'Unable to create a proxy to "{name}" on {parentIp}:{parentPort}.'.format( name = name, parentIp = self.parentIp, parentPort = self.parentPort ) );
            sys.exit( 1 );
            
        return proxy;
    
    
    


