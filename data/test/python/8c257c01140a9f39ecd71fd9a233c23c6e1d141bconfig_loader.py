# -*- coding: utf-8 -*-
"""

    deployr

    created by hgschmidt on 29.12.12, 13:28 CET
    
    Copyright (c) 2012 - 2013 apitrary

"""
import logging


class ConfigLoader(object):
    """
        Deployr base object. Used for configurations.
    """

    def __init__(self, config):
        """
            Transfer configuration object into this class.
        """
        super(ConfigLoader, self).__init__()
        self.config = config
        self.read_config()

    def get(self, name):
        """
            Get a single variable from the config object
        """
        if name in self.config:
            return self.config[name]
        else:
            logging.error("Config variable:{} does not exist.".format(name))
            return ''

    def read_config(self):
        """
            Read out the config object
        """
        self.supervisord_host = self.get("SUPERVISORD_HOST")
        self.supervisord_web_port = self.get("SUPERVISORD_WEB_PORT")
        self.supervisord_xml_rpc_username = self.get("SUPERVISOR_XML_RPC_USERNAME")
        self.supervisord_xml_rpc_password = self.get("SUPERVISOR_XML_RPC_PASSWORD")
        self.supervisord_xml_rpc_server = self.get("SUPERVISOR_XML_RPC_SERVER_ADDRESS")
        self.rmq_broker_password = self.get("BROKER_PASSWORD")
        self.rmq_broker_username = self.get("BROKER_USER")
        self.rmq_broker_prefetch_count = self.get("BROKER_PREFETCH_COUNT")
        self.rmq_broker_host = self.get("BROKER_HOST")
        self.rmq_broker_port = self.get("BROKER_PORT")
        self.logging_level = self.get("LOGGING")
        self.environment = self.get("ENV")
        self.config_file = self.get("DEPLOYR_CONFIG_FILE")
        self.service_name = self.get("SERVICE")
        self.debug = True if self.get("DEBUG") == "1" or self.get("DEBUG") == True else False
        self.loadbalancer_api_base_name = self.get("LOADBALANCER_API_BASE_NAME")
        self.loadbalancer_host = self.get("LOADBALANCER_HOST")
        self.loadbalancer_riak_pb_port = self.get("LOADBALANCER_RIAK_PB_PORT")
        self.loadbalancer_riak_rest_port = self.get("LOADBALANCER_RIAK_REST_PORT")

    def show_all_settings(self):
        """
            Show all configured constants
        """
        logging.info('Starting service: deployr')
        logging.info('Environment: {}'.format(self.environment))
        logging.info('Logging: {}'.format(self.logging_level))
        logging.info('Config file: {}'.format(self.config_file))
        logging.info('Service: {}'.format(self.service_name))
        logging.info('Debug: {}'.format("ON" if self.debug == True else "OFF"))
        logging.info('Loadbalancer HOST: {}'.format(self.loadbalancer_host))
        logging.info('Loadbalancer API base name: {}'.format(self.loadbalancer_api_base_name))
        logging.info('Loadbalancer Riak Protobuf port: {}'.format(self.loadbalancer_riak_pb_port))
        logging.info('Loadbalancer Riak REST port: {}'.format(self.loadbalancer_riak_rest_port))
        logging.info('Supervisor host: {}'.format(self.supervisord_host))
        logging.info('Supervisor web port: {}'.format(self.supervisord_web_port))
        logging.info('Supervisor XML-RPC Server address: {}'.format(self.supervisord_xml_rpc_server))
        logging.info('Supervisor XML-RPC Server user: {}'.format(self.supervisord_xml_rpc_username))
        logging.info('RabbitMQ Broker username: {}'.format(self.rmq_broker_username))
        logging.info('RabbitMQ Broker prefetch: {}'.format("ON" if self.rmq_broker_prefetch_count == True else "OFF"))
        logging.info('RabbitMQ Broker host: {}'.format(self.rmq_broker_host))
        logging.info('RabbitMQ Broker port: {}'.format(self.rmq_broker_port))
