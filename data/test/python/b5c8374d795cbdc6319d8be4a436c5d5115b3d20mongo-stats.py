#!/usr/bin/python

import urllib
import json
import time
import sys

""" set following variables according to your setup """
# run script every 60 seconds
INTERVAL = 60

# mongo
MONGO_PORT = 28017 # web interface
MONGO_HOST = 'localhost' # CHANGE ME


def fetch_info(host, port):
    """ connect to mongo and fetch server status """
    try:
        m_info = urllib.urlopen('http://' + host + ':' + str(port) + '/serverStatus').read()
        j_info = json.loads(m_info)
        return j_info
    except:
        print 'Could not connect to mongo, please check if port and hostname is right.'


def print_stat(metric, value, tags=""):
    """ prints values in hbase schema format """
    ts = int(time.time())
    if value is not None:
        print "mongo.%s %d %s %s" % (metric, ts, value, tags)


def dispatch_value(info, identifier, metric, extra_info=None):
    ts = int(time.time())
    if extra_info:
        return print_stat(identifier + '.' + metric + '.' + extra_info,
                          info[identifier][metric][extra_info],
                          'mongohost=' + MONGO_HOST)

    return print_stat(identifier + "." + metric,
                      info[identifier][metric],
                      'mongohost=' + MONGO_HOST)


def main():
    """ mongo-stats main loop """

    while True:

    # connect to instance and gather info
        info = fetch_info(MONGO_HOST, MONGO_PORT)
        dispatch_value(info, 'mem', 'resident')
        dispatch_value(info, 'mem', 'virtual')
        dispatch_value(info, 'mem', 'mapped')

        dispatch_value(info, 'network', 'bytesIn')
        dispatch_value(info, 'network', 'bytesOut')
        dispatch_value(info, 'network', 'numRequests')

        dispatch_value(info, 'opcounters', 'insert')
        dispatch_value(info, 'opcounters', 'query')
        dispatch_value(info, 'opcounters', 'update')
        dispatch_value(info, 'opcounters', 'delete')
        dispatch_value(info, 'opcounters', 'getmore')
        dispatch_value(info, 'opcounters', 'command')

        dispatch_value(info, 'connections', 'current')
        dispatch_value(info, 'connections', 'available')

        dispatch_value(info, 'extra_info', 'heap_usage_bytes')
        dispatch_value(info, 'extra_info', 'page_faults')

        dispatch_value(info, 'asserts', 'regular')
        dispatch_value(info, 'asserts', 'warning')
        dispatch_value(info, 'asserts', 'msg')
        dispatch_value(info, 'asserts', 'user')
        dispatch_value(info, 'asserts', 'rollovers')

        dispatch_value(info, 'indexCounters', 'btree', 'missRatio')
        dispatch_value(info, 'indexCounters', 'btree', 'resets')
        dispatch_value(info, 'indexCounters', 'btree', 'hits')
        dispatch_value(info, 'indexCounters', 'btree', 'misses')
        dispatch_value(info, 'indexCounters', 'btree', 'accesses')

        dispatch_value(info, 'globalLock', 'totalTime')
        dispatch_value(info, 'globalLock', 'lockTime')
        dispatch_value(info, 'globalLock', 'ratio')
        dispatch_value(info, 'globalLock', 'currentQueue', 'total')
        dispatch_value(info, 'globalLock', 'currentQueue', 'readers')
        dispatch_value(info, 'globalLock', 'currentQueue', 'writers')
        dispatch_value(info, 'globalLock', 'activeClients', 'total')
        dispatch_value(info, 'globalLock', 'activeClients', 'readers')
        dispatch_value(info, 'globalLock', 'activeClients', 'writers')

        sys.stdout.flush()
        # run every 60 seconds
        time.sleep(INTERVAL)

if __name__ == "__main__":
    sys.exit(main())
