#-*-coding:utf-8-*-

'use restful api to monitor activemq broker'

__author__ = 'afred.lyj'
import  httplib
import  urllib
import base64
import json
import logging
from logging.handlers import TimedRotatingFileHandler

logHandler = TimedRotatingFileHandler("logfile.log",when="d", interval=1, backupCount=5)
logFormatter = logging.Formatter('%(asctime)s %(name)-12s %(levelname)-8s %(message)s')
logHandler.setFormatter(logFormatter)
logHandler.suffix = "%Y%m%d"  # 设置后缀
logger = logging.getLogger('activemqMonitorLog')
logger.addHandler(logHandler)
logger.setLevel(logging.INFO)

username = 'admin'
password = 'admin'

mqList='192.168.1.101:8161:example.MyQueue,opaycenter_queue_notify_2000;192.168.1.102:8161:example.MyQueue,opaycenter_queue_notify_2000'

#logging.basicConfig(filename="activemqMonitor.log", level=logging.DEBUG)

def parseMqList(mqList):
    li = mqList.split(';')
    l = list()
    for entry in li:
        d = dict()
        broker = entry.split(':')
        d['host'] = broker[0]
        d['port'] = broker[1]
        queues = broker[2].split(',')
        d['queues'] = queues
        l.append(d)
    return l

def httpGet(host,port,url,timeout=10):
    #print("httpget the host:%s,port:%d, the param:%s" %(host,port,url))
    base64String = base64.encodestring('%s:%s' % (username, password))
    authHeader = 'Basic %s' % base64String
    headers = {'Authorization': authHeader}
    try:
        conn = httplib.HTTPConnection(host,port=port,timeout=timeout)
        conn.request("GET",url, None, headers)
        response = conn.getresponse()
        #print("status:"+str(response.status)+", reason:"+str(response.reason))
        if response.status == httplib.OK:
            data = response.read()
            return data
    except Exception, e:
        logger.error(e)
        return "";

def checkBrokerAttribute(host, port, attribute):
    uri = "/api/jolokia/read/org.apache.activemq:type=Broker,brokerName=localhost/" + attribute
    response = httpGet(host, port, uri)
    #print response

    if response:
        result = json.loads(response)
        percent = result['value']
        if percent >= 10:
            print "alert : the usage of broker memory arrived %d" % percent
            return True
        else:
            print "everything is ok, haha"
            return False
    else:
        print "alert : mq broker is shutdown, please try to restart it"
        return True

def checkBroker(host, port):
    return checkBrokerAttribute(host, port, 'MemoryPercentUsage') or checkBrokerAttribute(host, port, 'StorePercentUsage')

def checkQueue(host, port, queueName):
    uri = "/api/jolokia/read/org.apache.activemq:type=Broker,brokerName=localhost,destinationType=Queue,destinationName=%s/" % queueName
    #print uri
    response = httpGet(host, port, uri)
    #print response

    if response:
        result = json.loads(response)
        values = result.get('value')
        #print values
        queueSize = values.get('QueueSize')
        if queueSize > 10:
            print "current queue size is %d, need alert" % queueSize
        memoryPercentUsage = values.get('MemoryPercentUsage')
        if memoryPercentUsage > 10:
            print 'current queue memory percent usage %d, need alert' % memoryPercentUsage
    else:
        print 'no response from activemq broker, need alert'


if __name__=='__main__':
    logger.info("hello")
    l = parseMqList(mqList)
     #print l
    for broker in l:
        brokerDown = checkBroker(broker['host'], int(broker['port']))
        #print brokerDown
        if brokerDown:
            continue;

        #checkBroker(broker['host'], int(broker['port']), 'StorePercentUsage')
        queues = broker.get('queues')
        for queue in queues:
            checkQueue(broker['host'], int(broker['port']), queue)
    

