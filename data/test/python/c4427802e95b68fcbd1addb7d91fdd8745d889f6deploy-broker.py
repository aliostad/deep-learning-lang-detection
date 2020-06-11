#!/usr/bin/env python

import time, sys, os, config

from comodit_client.api import Client
from comodit_client.api.exceptions import PythonApiException
from comodit_client.api.collection import EntityNotFoundException
from comodit_client.rest.exceptions import ApiException
from comodit_client.api.host import Host

from optparse import OptionParser

from helper import create_host, get_short_hostname, track_changes, generate_id


def deploy():

    # Script
    start_time = time.time()

    # Connect to the ComodIT API
    client = Client(config.endpoint, config.username, config.password)
    env = client.get_environment(config.organization, 'Openshift')
    
    # Configure environment
    try:
      env.settings().create("domain", config.domain)
    except:
      print "Did not reconfigure domain since a setting was already defined. Run teardown if you wanted to cleanup first"

    # Deploy Openshift Broker
    try:
      broker = env.get_host('Openshift Broker')
    except EntityNotFoundException:
      broker = create_host(env, 'Openshift Broker', config.platform, config.distribution, [])
      print "Deploying Openshift Broker"
      broker.provision()
      broker.refresh()

    # Wait for Broker to be deployed and retrieve IP
    if broker.state == "PROVISIONING":
      print "Waiting for Broker to be deployed"
      broker.wait_for_state('READY', config.time_out)
      if broker.state == "PROVISIONING":
          raise Exception("Timed out waiting for host to be provisioned.")

    # Get the broker IP address
    broker_ip = broker.get_instance().wait_for_property("ip.eth0", config.time_out)
    if broker_ip is None:
        raise Exception("Failed to retrieve the host IP")

    # Configure broker
    print "Installing the Bind server"
    broker.install("openshift-bind-server", {"dns_records": [{"host":"broker", "type": "A", "ttl": "180", "target": broker_ip}]})
    track_changes(broker)

    # Update environment settings with nameserver
    env.settings().create("nameserver", broker_ip)

    # Configure Network
    print "Reconfiguring network"
    broker.install("openshift-dhcp-dns-config", {"hostname": "broker"})
    track_changes(broker)
    
    # Install Mongo
    print "Installing MongoDB"
    mongo_pw = generate_id(12)
    broker.install("openshift-mongodb", {"smallfiles": True, "secure": True, "users": [{"database": "openshift", "username": "openshift", "password": mongo_pw}]})
    track_changes(broker)

    # Install RabbitMQ
    print "Installing RabbitMQ"
    broker.install("openshift-rabbitmq-server", {})
    track_changes(broker)

    # Install Mcollective client
    print "Installing MCollective Client"
    broker.install("openshift-mcollective-client", {})
    track_changes(broker)

    # Install Broker
    print "Installing Openshift Broker"
    broker.install("openshift-broker", {"mongo_database": "openshift", "mongo_user": "openshift", "mongo_password": mongo_pw})
    track_changes(broker)

    # Cleanup changes
    broker.changes().clear()

    # Get broker public hostname
    public_hostname = broker.get_instance().wait_for_address(config.time_out)
    print "Openshift broker deployed at %s" % public_hostname

    total_time = time.time() - start_time
    print "Deployment time: " + str(total_time)

if __name__ == '__main__':
    try:
        deploy()
    except PythonApiException as e:
        print e
