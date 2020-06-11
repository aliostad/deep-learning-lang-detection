#!/usr/bin/env python
# -*- coding: utf-8 -*-
#config.py for Config File in /home/loic/GitHub/Moustash/moustash
#
#Made by Loic Tosser, Wowi.io
#Login   <loic@wowi.io>
#
#

import ConfigParser
import redis
import pika
import os.path
import sys
from utils import config_section_map

class Franck:
    def __init__(self):
        self.config = ConfigParser.ConfigParser()
        if os.path.isfile("/usr/local/etc/moustash/moustash.ini") == False:
            print "Configuration file (/usr/local/etc/moustash/moustash.ini) not found !!!"
            print "Exit !!!"
            sys.exit(1)
        self.config.read("/usr/local/etc/moustash/moustash.ini")
        self.moustash_config = {}
        self.moustash_config["Moustash"] = config_section_map(self.config, "Moustash")
        self.moustash_config["Cuir"] = config_section_map(self.config, "Cuir")
        self.broker = {}
        if self.moustash_config["Moustash"]["transport"] == "redis":
            redis_parameters = {"redis_host" : "localhost", "redis_port" : "6379", "redis_db" : "0", "redis_namespace": "logstash:moustash"}
            self.fill_broker_options(redis_parameters)
            self.broker_connection = self.connect_to_redis()
        elif self.moustash_config["Moustash"]["transport"] == "rabbitmq":
            rabbitmq_parameters = {"rabbitmq_host" : "localhost", "rabbitmq_port": "5672",
                                   "rabbitmq_ssl" : "0", "rabbitmq_ssl_key" : None, 
                                   "rabbitmq_ssl_cert" : None, "rabbitmq_ssl_cacert" : None,
                                   "rabbitmq_vhost" : "/", "rabbitmq_username" : "guest",
                                   "rabbitmq_password" : "guest",
                                   "rabbitmq_queue" : "logstash-queue", "rabbitmq_queue_durable" : "0",
                                   "rabbitmq_exchange_type" : "direct", "rabbitmq_exchange_durable" : "0",
                                   "rabbitmq_key" : "logstash-key", "rabbitmq_exchange" : "logstash-exchange"}
            self.fill_broker_options(rabbitmq_parameters)
            self.broker_connection = self.connect_to_rabbitmq()
        else:
            print("Not yet implemented : %s !" % moustash_config["Moustash"]["transport"])
            

    def fill_broker_options(self, options):
        for option_name, option_value in options.iteritems():
            if option_name in self.moustash_config["Moustash"]:
                self.broker[option_name] = self.moustash_config["Moustash"][option_name]
            else:
                self.broker[option_name] = option_value

    def connect_to_redis(self):
        r = redis.StrictRedis(host=self.broker["redis_host"], port=int(self.broker["redis_port"]), db=int(self.broker["redis_db"]))
        return r

    def connect_to_rabbitmq(self):
        credentials_rabbitmq = pika.PlainCredentials(self.broker["rabbitmq_username"], self.broker["rabbitmq_password"])
        parameters_rabbitmq = pika.ConnectionParameters(host=self.broker["rabbitmq_host"], port=int(self.broker["rabbitmq_port"]),
                                                        virtual_host=self.broker["rabbitmq_vhost"], credentials=credentials_rabbitmq)
        connection = pika.BlockingConnection(parameters_rabbitmq)
        channel = connection.channel()
        channel.queue_declare(queue=self.broker["rabbitmq_queue"], durable=self.broker["rabbitmq_queue_durable"])
        channel.exchange_declare(exchange=self.broker["rabbitmq_exchange"], exchange_type=self.broker["rabbitmq_exchange_type"], durable=self.broker["rabbitmq_exchange_durable"])
        channel.queue_bind(exchange=self.broker["rabbitmq_exchange"], queue=self.broker["rabbitmq_queue"], routing_key=self.broker["rabbitmq_key"])
        return channel
        
    def push_moustash(self, json_message):
        if self.moustash_config["Moustash"]["transport"] == "redis":
            self.broker_connection.rpush(self.broker["redis_namespace"], json_message)
        if self.moustash_config["Moustash"]["transport"] == "rabbitmq":
            self.broker_connection.basic_publish(exchange=self.broker["rabbitmq_exchange"], routing_key=self.broker["rabbitmq_key"], body=json_message)
