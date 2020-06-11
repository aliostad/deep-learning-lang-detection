import os
import sys
import time
sys.path.insert(0, os.path.abspath("../"))

import unittest

import nimboss.nimbus
from nimboss.nimbus import NimbusClusterDocument
from nimboss.broker import ContextResource, BrokerClient
from nimboss.node import NimbusNodeDriver, EC2NodeDriver
from nimboss.cluster import Cluster, ClusterDriver


class TestClusterDocLoadParse(unittest.TestCase):

    def setUp(self):
        self.clusterdoc = open("test_ec2_clusterdoc.xml").read()
        self.context_uri = "http://example.com/"
        self.context_body = {
            'brokerUri':'test_broker_uri', 
            'contextId':'test_context_id', 
            'secret':'test_secret'
        }

    def test_loadparse(self):
        nimbuscd = NimbusClusterDocument(self.clusterdoc)
        self.assertEqual(len(nimbuscd.members), 2)
        self.assertEqual(nimbuscd.members[0].quantity, 1)
        self.assertEqual(nimbuscd.members[1].quantity, 2)

    def test_build_specs(self):
        nimbuscd = NimbusClusterDocument(self.clusterdoc)
        ctx = ContextResource(self.context_uri, self.context_body)
        specs = nimbuscd.build_specs(ctx)
        self.assertEqual(len(specs), 2)
        self.assertEqual(specs[0].count, 1)
        self.assertEqual(specs[1].count, 2)
        self.assertEqual(specs[0].image, "ami-b48765dd")
        for spec in specs:
            print "spec:"
            print spec.userdata

    def test_create_contact_element(self):
        ctx = ContextResource(self.context_uri, self.context_body)
        contact = nimboss.nimbus.create_contact_element(ctx)
        #assure that all elements have a namespace prefix
        for child in contact.getiterator():
            self.assertTrue(str(child.tag)[0] == '{')


class TestEC2Cluster(unittest.TestCase):

    def setUp(self):
        self.clusterdoc = open("test_ec2_clusterdoc.xml").read()
        self.context_uri = "http://example.com/"
        self.context_body = {
            'broker_uri':'test_broker_uri', 
            'context_id':'test_context_id', 
            'secret':'test_secret'
        }
        self.broker_uri = "http://example.com/"
        self.broker_key = "broker_key"
        self.broker_secret = "broker_secret"
        self.cloud_key = os.environ["AWS_KEY"]
        self.cloud_secret = os.environ["AWS_SECRET"]

    def test_start_cluster(self):
        broker_client = BrokerClient(self.broker_uri, self.broker_key, self.broker_secret)  

        node_driver = EC2NodeDriver(self.cloud_key, self.cloud_secret)
        cluster_driver = ClusterDriver(broker_client, node_driver)
        cluster = Cluster(self.context_uri, cluster_driver)

        fake_context = ContextResource(self.context_uri, self.context_body)
        cluster.create_cluster(self.clusterdoc, context=fake_context)


class TestNimbusCluster(unittest.TestCase):

    def setUp(self):
        self.clusterdoc = open("test_nimbus_clusterdoc.xml").read()
        self.cloud_key = os.environ["NIMBUS_KEY"]
        self.cloud_secret = os.environ["NIMBUS_SECRET"]
        self.broker_uri = "https://nimbus.ci.uchicago.edu:8888/ContextBroker/ctx/"
        self.broker_key = self.cloud_key
        self.broker_secret = self.cloud_secret

    def test_start_cluster(self):
        broker_client = BrokerClient(self.broker_uri, self.broker_key, self.broker_secret)  

        node_driver = NimbusNodeDriver(self.cloud_key, self.cloud_secret)
        cluster_driver = ClusterDriver(broker_client, node_driver)

        context = broker_client.create_context()
        print "Context uri:", context
        cluster = cluster_driver.create_cluster(self.clusterdoc, context=context, keyname="default")
        print "Cluster: ", cluster
        for node in cluster.nodes.values():
            print "Node %s (%s)" % (node.id, node.name)

        all_done = False
        while not all_done:
            time.sleep(5)
            status = cluster.get_status()
            all_done = (status['isComplete'] and
                    (status['allOk'] or status['errorOccurred']))

        print "Context complete!"
        print "Status: ", status
        cluster.destroy()

if __name__ == '__main__':
    unittest.main(argv=sys.argv)
