# These are the classes used to Serve commands to the Raspberry Pis in the
# Gray Lab conditioning cage project
# Sam Rendall

from twisted.spread import pb
from twisted.internet.defer import maybeDeferred

class RpiRoot(pb.Referencable)

    def remote_registerPi(self, iden, refs):
        """
        Each pi will call this method first to send identifiers and references to the server

        identity is a dict containing identifiers about the pi:
            hostname: <string> the pi's hostname
            ip: <str> the pi's ip address

        refs is a dict containing remoteReferences to the pi's Referencable objects
            experimentalProtocols:
            camera:
        """
        # Unpack Identifiers
        self.broker.clientName = iden['name']
        self.broker.clientType = iden['clientType']
        # Unpack References
 
        self.broker.registerWithFactory()


class RPiServerBroker(pb.Broker):
    """
    I am the broker object used to handle connections and remote function calls with the
    Raspberry Pis.  At the moment, I don't do anything
    """
    clientName = None
    clientType = None
    cameraControls = None

    def registerWithFactory(iden):
        self.factory.connectedBrokers[self.clientName] = self

class RootDistributer(pb.Root):
    """ I create root objects for each broker.  This allows each broker to have its own root 
    object that knows who it is owned by (as opposed to the default behavior which is for me to serve
    as the root object for all brokers)
    """

    def rootObject(self, broker):
        root = RpiRoot()
        root.broker = broker
        return root

class RPiServerFactory(pb.PBServerFactory):
    """
    I am the server factory for establishing connections with new raspberry pis.

    Whenever a Raspberry Pi connects to me, I insantiate a RPiBroker to handle that connection.

    When the PBClientFactory on the pi's end calls getrootobject, I return a reference to an instance
    of RPiRoot.
    """
    connectedBrokers = {}
    connectedBrokersByType = {}

    protocol = RPiServerBroker

