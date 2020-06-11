import time
from cpe_provisioner_ec2 import EC2Config
from cpe_provisioner_context import ContextClient


if __name__ == "__main__":
    import sys
    broker_url = sys.argv[1] # e.g: https://tp-x001.ci.uchicago.edu:8443/wsrf/services/NimbusContextBroker 
    broker_id = sys.argv[2] # e.g: /C=ae5d95ac-30aa-4c6b-b92c-84f25c7f3455/CN=localhost

    print broker_url, broker_id

    #clusterfile = EC2Config("test-1", "ami-xxxxxx", "xxx-keypair-xxx").toWorkspaceXml()
    clusterfile = open("harness.xml").read()
    contextClient = ContextClient(broker_url, broker_id)
    lds = contextClient.createFromString(clusterfile) #launch descriptions
    import pdb; pdb.set_trace()
    time.sleep(2)
    print contextClient.monitor()
