#!/usr/bin/python

#requirement: need to install kafka python client (https://github.com/quixey/kafka-python)

 
from kafka.client import KafkaClient
from kafka.consumer import SimpleConsumer
from kafka.producer import SimpleProducer

from time import gmtime, strftime, localtime
import sys

if __name__ == "__main__":
    
    broker_name = sys.argv[1]
    broker_port = sys.argv[2]
    
    print "Broker:",broker_name,broker_port
    kafka = KafkaClient(broker_name,int(broker_port))
    
    producer = SimpleProducer(kafka, "flow", async=True)
    
    time = strftime("%H:%M:%S", localtime())
    producer.send_messages("DFA is great!"+time)
