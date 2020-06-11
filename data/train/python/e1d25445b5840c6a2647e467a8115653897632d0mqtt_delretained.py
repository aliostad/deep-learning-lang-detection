#!/usr/bin/python3
# -*- coding: utf-8 -*-
import getopt, os, sys, paho.mqtt.publish as publish

def usage():
    """
    Usage function
    """
    print("""Usage: %s -b <Broker IP-address:Port> -t <topic>

-h    Show this help message and exit
-b    Specify different broker IP-address and port, default "jedibroker.ikp.kfa-juelich.de:1883"
-t    Retained MQTT topic to delete
""" % sys.argv[0])


def main(argv):
    brokerIP = "jedibroker.ikp.kfa-juelich.de"#"134.94.220.203"
    brokerPort = 1883
    # read CMD-arguments given
    try:         
        opts, args = getopt.getopt(argv, "hb:t:")
    except getopt.GetoptError as err:
        print(str(err)+"\n")
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt == "-h":
            usage()
            sys.exit()
        elif opt == "-b":
            brokerIP= arg.split(":")[0]
            brokerPort = float(arg.split(":")[1])
        elif opt == "-t":
            topic = str(arg)
            
    try:
        uid = "delretained_"+str(os.getpid())
        payload = [(topic, None, 0, True)]
        publish.multiple(payload, brokerIP, brokerPort, uid)
        print("Deleting "+topic+" from "+brokerIP+":"+str(brokerPort))
    except:     
        print("Broker %s:%s not found" % (brokerIP, brokerPort))
        sys.exit(2)
            
if __name__ == "__main__":
    main(sys.argv[1:])
