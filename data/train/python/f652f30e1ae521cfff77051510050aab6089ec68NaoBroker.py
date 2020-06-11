import roslib;
roslib.load_manifest( 'nao_core' );
import rospy;

import sys;

from naoqi import ALBroker;

class NaoBroker( object ):
    """
    NaoBroker
    """
    BROKER_IP = '0.0.0.0';
    BROKER_PORT = 0;

    def __init__( self, parentIp, parentPort ):
        self.parentIp = parentIp;
        self.parentPort = parentPort;
        
        # Create a broker.
        try:
            self.broker = ALBroker( 'nao_utils_broker_{id}'.format( id = id( self ) ), self.BROKER_IP, self.BROKER_PORT, self.parentIp, self.parentPort );
        except RuntimeError, e:
            rospy.logerr( 'Unable to create a proxy to the NaoQi broker on {parentIp}:{parentPort}.'.format( parentIp = self.parentIp, parentPort = self.parentPort ) );
            sys.exit( 1 );

'''
    instance = None;

    def __init__( self, parentIp, parentPort ):
        if( NaoBroker.instance == None ):
            self.parentIp = parentIp;
            self.parentPort = parentPort;
            
            # Create a broker.
            try:
                self.broker = ALBroker( 'nao_utils_broker_{id}'.format( id = id( self ) ), self.BROKER_IP, self.BROKER_PORT, self.parentIp, self.parentPort );
            except RuntimeError, e:
                rospy.logerr( 'Unable to create a proxy to the NaoQi broker on {parentIp}:{parentPort}.'.format( parentIp = self.parentIp, parentPort = self.parentPort ) );
                sys.exit( 1 );
                
            NaoBroker.instance = self;
'''