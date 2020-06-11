#!/usr/bin/env python

from optparse import OptionParser
from kafka import KafkaConsumer

def kafkacat(topic,hosts):
    consumer = KafkaConsumer(topic,
                             bootstrap_servers=hosts,
                             group_id='kafkacat')

    for message in consumer:
        print("%s:%d:%d key=%s value=%s" % (message.topic,
                                            message.partition,
                                            message.offset,
                                            message.key,
                                            message.value))

def main():
    parser = OptionParser(usage="usage: %prog [options] ")
    parser.add_option("-b","--broker",
                      action="store",
                      dest="broker",
                      default="localhost:9092",
                      help="Kafka Broker hosts")
    parser.add_option("-t","--topic",
                      action="store",
                      dest="topic",
                      help="listen Kafka topic")

    (options,args) = parser.parse_args()

    kafkacat(options.topic,options.broker.split(','))

if __name__ == "__main__":
    main()
