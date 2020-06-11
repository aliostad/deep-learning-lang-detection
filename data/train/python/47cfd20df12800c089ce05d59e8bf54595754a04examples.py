import os
from nimboss.broker import BrokerClient
from nimboss.cluster import NimbusClusterDriver
from nimboss.node import NimbusNodeDriver

BROKER_URI = "http://mybroker.edu"
NIMBUS_URI = "http://mycloud.edu"


def main():
    key, secret = os.environ["NIMBUS_KEY"], os.environ["NIMBUS_SECRET"]

    # in this example we are using the same credentials for broker and nimbus
    # this would be different if we were launching on say, EC2
    brokerclient = BrokerClient(BROKER_URI, key, secret)
    ndriver = NimbusNodeDriver(key, secret, host=NIMBUS_URI) 
    cdriver = NimbusClusterDriver(brokerclient, node_driver=ndriver)

    clusterdoc = open("/path/to/myclusterdoc.xml").read()
    cluster = cdriver.create_cluster(clusterdoc) # return value is a Cluster

    print "Starting cluster....", cluster
    context_done = False
    while not context_done:
        time.sleep(5)
        status = cluster.get_status()
        print "Cluster status =>", status
        context_done = status.complete

if __name__ == "__main__":
    main()

